+++
title = "Firebase Preview Channel Clean Up"
date = 2026-06-07T14:06:39+08:00
tags = ["firebase", "github-actions", "ci"]
categories = ["devops"]
draft = false
+++

Firebase Hosting preview channels pile up fast — every PR spins one up, and they linger long after the PR is merged or closed. This GitHub Action lists every preview channel, maps each back to its PR, and (optionally) deletes the ones whose PR is already closed or merged.

It runs on a **weekly schedule** (auto-deletes merged/closed) and supports a **manual trigger** with a toggle for whether to actually delete.

---

## Overview

| Trigger | Behaviour |
|---|---|
| `workflow_dispatch` (manual) | Lists all channels. Deletes only if `delete_closed = true` |
| `schedule` (Fri 09:00 HKT) | Lists all channels **and** auto-deletes merged/closed PRs |

---

## How it works

1. **Authenticate** — writes the service-account JSON to a temp file, points `GOOGLE_APPLICATION_CREDENTIALS` at it, and extracts the `project_id` to use as the Firebase project.
2. **List channels** — runs `firebase hosting:channel:list --json`, then a Python script parses the output into a readable table (channel, PR, status, days left, expiry, URL). Channel ids are matched against a `pr-<number>` regex to recover the PR number, and each PR's state is fetched via `gh api`.
3. **Delete closed/merged** — re-extracts the PR-style channels, checks each PR's state, and runs `firebase hosting:channel:delete` for any PR that is `closed` (GitHub reports merged PRs as `closed` with `merged_at` set). Open PRs are kept; not-found PRs are skipped for manual review.

---

## Gotchas worth noting

| Gotcha | Handling |
|---|---|
| `firebase --json` writes errors to **stdout** | Don't trust exit code + redirect blindly — the script dumps both `stderr` and `channels.json` on failure |
| GitHub `.state` only returns `open`/`closed` | Merged PRs are `closed` with `merged_at` set → label resolved from `merged_at` |
| Channel JSON shape varies | Defensive unwrapping of `result` / `channels` at multiple nesting levels |
| `GITHUB_TOKEN` permissions | Scoped to `contents: read` + `pull-requests: read` only |

---

## The full workflow

```yaml
name: Firebase Preview Channels Cleanup

on:
  workflow_dispatch:        # manual trigger only
    inputs:
      delete_closed:
        description: 'Delete channels whose PR is closed/merged'
        type: boolean
        default: false
  schedule:
    - cron: '0 1 * * 5'     # Friday 09:00 HKT (01:00 UTC) — auto-delete merged/closed

permissions:
  contents: read
  pull-requests: read

jobs:
  list-channels:
    runs-on: ubuntu-latest
    env:
      GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      DELETE_CLOSED: ${{ inputs.delete_closed }}
    steps:
      - name: Checkout
        uses: actions/checkout@v5

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Firebase CLI
        run: npm install -g firebase-tools

      - name: Authenticate to Firebase
        run: |
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}' > "$RUNNER_TEMP/sa.json"
          echo "GOOGLE_APPLICATION_CREDENTIALS=$RUNNER_TEMP/sa.json" >> "$GITHUB_ENV"
          PROJECT_ID=$(python3 -c "import json;print(json.load(open('$RUNNER_TEMP/sa.json'))['project_id'])")
          echo "FIREBASE_PROJECT=$PROJECT_ID" >> "$GITHUB_ENV"
          echo "Using Firebase project: $PROJECT_ID"

      - name: List preview channels (channel, PR id, expire date)
        run: |
          echo "Project: $FIREBASE_PROJECT"
          echo "Creds present: $(test -s "$GOOGLE_APPLICATION_CREDENTIALS" && echo yes || echo no)"
          firebase --version

          # --json writes errors to stdout too, so don't blindly trust exit + redirect
          if ! firebase hosting:channel:list \
                --project "$FIREBASE_PROJECT" \
                --json > channels.json 2> fb_err.txt; then
            echo "::error::firebase hosting:channel:list failed"
            echo "--- stderr ---"; cat fb_err.txt
            echo "--- channels.json (may hold the JSON error) ---"; cat channels.json
            exit 1
          fi

          python3 - <<'PY'
          import json, datetime, re, os, subprocess

          repo = os.environ.get("GITHUB_REPOSITORY", "")

          _status_cache = {}
          def pr_status(pr):
              # open | merged | closed | not-found | unknown
              if pr in _status_cache:
                  return _status_cache[pr]
              status = "unknown"
              if repo:
                  try:
                      out = subprocess.run(
                          ["gh", "api", f"repos/{repo}/pulls/{pr}",
                           "--jq", "[.state, (.merged_at // \"\")] | @tsv"],
                          capture_output=True, text=True, timeout=30,
                      )
                      if out.returncode == 0:
                          state, merged_at = (out.stdout.strip().split("\t") + [""])[:2]
                          status = "merged" if merged_at else state
                      else:
                          status = "not-found"
                  except Exception:
                      status = "unknown"
              _status_cache[pr] = status
              return status

          with open("channels.json") as f:
              data = json.load(f)

          result = data.get("result", data)
          channels = result.get("channels", result) if isinstance(result, dict) else result
          if isinstance(channels, dict):
              channels = channels.get("channels", [])

          rows = []
          now = datetime.datetime.now(datetime.timezone.utc)

          for ch in channels:
              name = ch.get("name", "")
              channel_id = name.rsplit("/", 1)[-1] if name else ch.get("channelId", "")
              expire = ch.get("expireTime", "")
              url = ch.get("url", "")

              m = re.match(r"pr[-_]?(\d+)(?:[-_]|$)", channel_id, re.IGNORECASE)
              pr_id = m.group(1) if m else ""

              days_left = ""
              if expire:
                  try:
                      exp_dt = datetime.datetime.fromisoformat(expire.replace("Z", "+00:00"))
                      days_left = str((exp_dt - now).days)
                  except ValueError:
                      pass

              rows.append({
                  "channel": channel_id,
                  "pr": pr_id or "-",
                  "status": pr_status(pr_id) if pr_id else "-",
                  "expire": expire or "never",
                  "days_left": days_left or "-",
                  "url": url,
              })

          rows.sort(key=lambda r: (r["pr"] == "-", r["expire"]))

          print(f'{"CHANNEL":<22}{"PR":<8}{"STATUS":<11}{"DAYS LEFT":<12}{"EXPIRES":<28}URL')
          print("-" * 120)
          for r in rows:
              print(f'{r["channel"]:<22}{r["pr"]:<8}{r["status"]:<11}{r["days_left"]:<12}{r["expire"]:<28}{r["url"]}')

          if not rows:
              print("No preview channels found.")
          PY

      - name: Delete channels for closed/merged PRs
        if: ${{ inputs.delete_closed || github.event_name == 'schedule' }}
        run: |
          # Extract PR-style channel ids and their PR numbers from channels.json
          python3 - <<'PY' > to_check.txt
          import json, re

          with open("channels.json") as f:
              data = json.load(f)

          result = data.get("result", data)
          channels = result.get("channels", result) if isinstance(result, dict) else result
          if isinstance(channels, dict):
              channels = channels.get("channels", [])

          for ch in channels:
              name = ch.get("name", "")
              channel_id = name.rsplit("/", 1)[-1] if name else ch.get("channelId", "")
              m = re.match(r"pr[-_]?(\d+)(?:[-_]|$)", channel_id, re.IGNORECASE)
              if m:
                  print(f"{channel_id}\t{m.group(1)}")
          PY

          if [ ! -s to_check.txt ]; then
            echo "No PR-style channels found to evaluate."
            exit 0
          fi

          while IFS=$'\t' read -r channel pr; do
            # GitHub API .state is only "open"|"closed"; merged PRs are "closed" with merged_at set.
            read -r state merged_at < <(
              gh api "repos/${GITHUB_REPOSITORY}/pulls/${pr}" \
                --jq '[.state, (.merged_at // "")] | @tsv' 2>/dev/null || echo "notfound"
            )

            if [ "$state" = "closed" ]; then
              label=$([ -n "$merged_at" ] && echo merged || echo closed)
              echo "PR #${pr} is ${label} -> deleting channel '${channel}'"
              firebase hosting:channel:delete "$channel" \
                --project "$FIREBASE_PROJECT" \
                --force
            elif [ "$state" = "open" ]; then
              echo "PR #${pr} is open -> keeping channel '${channel}'"
            else
              echo "PR #${pr} not found (state=${state}) -> skipping channel '${channel}' (review manually)"
            fi
          done < to_check.txt
```

---

## Required secrets

| Secret | Purpose |
|---|---|
| `FIREBASE_SERVICE_ACCOUNT` | Service-account JSON with Firebase Hosting admin rights |
| `GITHUB_TOKEN` | Auto-provided; used by `gh api` to read PR state |

Drop this at `.github/workflows/firebase-preview-channel-cleanup.yml` and the schedule takes care of the rest.

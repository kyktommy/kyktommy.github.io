+++
title = "Git Move Repo"
date = 2020-02-13T17:38:52+08:00
tags = ["git"]
categories = ["git"]
draft = false
+++

1. Clone the project from old repo url

    ```bash
    git clone <old_repo_url>
    ```

2. Pull all branches

    ```bash
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
    ```

3. Change remote to new repo url

    ```
    git remote set-url origin <new_repo>
    ```

4. Push all to new repo url

    ```
    git push --all
    git push --tags
    ```
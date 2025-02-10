+++
title = "Youtube Helper"
date = 2025-01-29T00:00:00+08:00
tags = ["youtube"]
categories = ["youtube"]
draft = false
+++

[yt-dlp](https://github.com/yt-dlp/yt-dlp) is a great tool to download youtube video, audio.

- download mac osx executable from github
- chmod +x yt-dlp
- brew install ffmpeg

Here is some helper script I used.

``` bash

# download as mp4, playlist also
function yt-mp4() {
  yt-dlp -f -f "[height<=720]"/mp4/bestvideo --yes-playlist $1
}

# download as mp3
function yt-mp3() {
  yt-dlp -x --audio-format mp3 --add-metadata $1
}

# download subtitle en
function yt-sub() {
  yt-dlp --write-sub --sub-lang en --skip-download $1
}

```
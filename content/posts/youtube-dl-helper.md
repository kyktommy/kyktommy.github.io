+++
title = "Youtube Dl Helper"
date = 2020-04-12T00:03:11+08:00
tags = ["youtube-dl"]
categories = ["script"]
draft = false
+++

[youtube-dl](https://github.com/ytdl-org/youtube-dl) is a great tool to download youtube stuff.

Here is some helper script I used.

``` bash

# download as mp4, playlist also
function youtube-dl-mp4() {
  youtube-dl -f "[height <=? 720][tbr>500]" --yes-playlist $1
}

# download as mp3
function youtube-dl-mp3() {
  youtube-dl -x --audio-format mp3 --add-metadata $1
}

# download subtitle en
function youtube-dl-sub() {
  youtube-dl --write-sub --sub-lang en --skip-download $1
}

```
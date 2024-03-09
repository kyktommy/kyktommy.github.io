+++
title = "Fix Exfat Drive in Mac Osx"
date = 2024-03-09T13:49:22+08:00
tags = [""]
categories = [""]
draft = false
+++

source: [gist - scottopell/fix_exfact_drive.md](https://gist.github.com/scottopell/595717f0f77ef670f75498bd01f8cab1)


Fix: 

1. `diskutil list`
1. get ID (eg: disk1s1)
1. `sudo fsck_exfat -d <ID>`
1. enter `YES` for prompt
1. drive will be mounted

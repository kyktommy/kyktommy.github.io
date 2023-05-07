+++
title = "Detect exfat disk in mac"
date = 2023-05-07T17:30:34+08:00
tags = ["mac", "exfat"]
categories = [""]
draft = false
+++

Cannot detect exfat external drive in my macbook. Here the solution,

1. `diskutil list` get the identifer of the disk, eg: `disk2s2`
1. `ps -ax | grep <identifier>` get the proccess id of `fsck`
1. `sudo kill -9 <process id>`

Alert pops up and I can access the disk in finder.

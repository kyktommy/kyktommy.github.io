+++
title = "Photo Recovery Using Mac"
date = 2022-06-15T00:10:42+08:00
tags = ["photo"]
categories = ["photo"]
draft = false
+++

Today my colleagues' SD card is corrupted. All photos are gone. Here is my steps to recover photos, videos using mac.

1. Plug the SD card in your mac, and choose `ignore` the corrupted sd card instead of `eject` when it prompt.
1. Download [testdisk](https://www.cgsecurity.org/wiki/TestDisk) using command `brew install testdisk`
1. Restart your mac.
1. Use command `sudo photorec`, must use `sudo` as administrator for detecting all disks.
1. Select the broken SD card disk, you can unplug and plug it back in to see which disk is the SD card.
1. Choose a distination folder, eg: `~/Desktop/recovery`
1. Click `Search`, it will start scan sectors, and save the images in distination folder.
1. Wait till its finished...... sd card is slow......
1. It may create multiple folders. Please look at result carefully.


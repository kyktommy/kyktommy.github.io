+++
title = "Golang Version Switch"
date = 2023-01-18T10:09:43+08:00
tags = ["golang"]
categories = ["golang"]
draft = false
+++

1. remove /usr/local/go if you install golang using pkg installer

```
sudo rm -rf /usr/local/go
sudo rm /etc/paths.d/go
```

2. use homebrew to install golang

```
brew install go
```

3. use homebrew to install golang different versions

```
brew install go@1.19
brew install go@1.18
```

4. switch between golang version, for example: switch from 1.18 to 1.19

```
brew unlink go
brew link go@1.19
```


+++
title = "Gpg Setup"
date = 2025-01-02T23:01:32+08:00
tags = ["ggp"]
categories = ["gpg"]
draft = false
+++

```shell
# install
brew install gpg2

# generate RSA 4096
gpg --full-generate-key # RSA 4096

# setup gpg program
git config --global gpg.program $(which gpg)

# setup gpg key from list
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey <your GPG key> 

# setup gpg sign when commit
git config --global commit.gpgsign true
```

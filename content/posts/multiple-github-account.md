+++
title = "Multiple Github Account"
date = 2021-05-10T14:50:58+08:00
tags = ["git"]
categories = ["git"]
draft = false
+++

Generate new ssh key for github account

```
$ ssh-keygen -t rsa -C "kyktommy@gmail.com" -f "id_rsa_kyktommy"
$ ssh-add ~/.ssh/id_rsa_kyktommy
```

Edit `.ssh/config`

```
# Account 1
Host github.com
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa
   
# New Account 2
Host github.com-kyktommy
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa_kyktommy
```

Add to ssh-agent

```
$ ssh-add ~/.ssh/id_rsa_kyktommy
```

Set public key in github setting

Clone github repo

```
$ git clone git@github.com-kyktommy:kyktommy/<repo_name>.git
```

Change local repo setting

```
$ git config user.name "kyktommy"
$ git config user.email "kyktommy@gmail.com"
```

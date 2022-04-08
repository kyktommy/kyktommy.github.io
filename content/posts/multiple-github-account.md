+++
title = "Multiple Github Account"
date = 2021-05-10T14:50:58+08:00
tags = ["git"]
categories = ["git"]
draft = false
+++

### Target

1. Setup multiple github accounts
2. Push to different account's remote repo automatically

### Setup

First, generate new ssh key for new github account.

```
$ ssh-keygen -t rsa -C "kyktommy@gmail.com" -f "id_rsa_kyktommy"
$ ssh-add ~/.ssh/id_rsa_kyktommy
```

Second, edit `.ssh/config`, there are 2 github account, which has different `Host`, they uses different rsa key for github.com.

```
# Account 1
Host github.com
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa
   
# Account 2
Host github.com-kyktommy
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa_kyktommy
```

### Github operation

Remember clone github repo with self-defined `Host` instead of just `github.com`.

```
$ git clone git@github.com-kyktommy:kyktommy/<repo_name>.git
```

or, update remote url in existing project.

```
$ git remote set-url origin git@github.com-kyktommy:kyktommy/<repo_name>.git
```

Besides, you can update the gitconfig for git commit author.

```
$ git config user.name "kyktommy"
$ git config user.email "kyktommy@gmail.com"
```

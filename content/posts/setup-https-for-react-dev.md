+++
title = "Setup https for react development"
date = 2022-04-01T11:58:58+08:00
tags = ["react"]
categories = ["react"]
draft = false
+++

### Installation

```bash
$ brew install mkcert
$ brew install nss
```

### Generate cert

```bash

$ cd ~
$ mkcert -install
$ mkcert localhost 127.0.0.1

```

### Use cert

in .bashrc define

```
export SSL_CRT_FILE=~/localhost+1.pem
export SSL_KEY_FILE=~/localhost+1-key.pem
```

start react with

```
HTTPS=true yarn start
```
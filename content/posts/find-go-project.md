+++
title = "Find Go Project"
date = 2019-12-22T18:41:34+08:00
tags = ["go"]
categories = ["go"]
draft = false
+++

I have so many go projects in go path. Since i didnt bookmarked all projects, so each time i need to go to `$GOPATH` and cd to that package name.

Here is my script for current solution. Assume your target project is in 3 depth of src.

```bash
function findgo() {
  find $GOPATH/src -mindepth 3 -maxdepth 3 -type d -exec ls -ld "{}" \; | grep $1 | awk '{ print $9 }' | nl
}
```

```console
➜  ~ findgo proto
     1	/Users/tommy/go-workspace/src/google.golang.org/genproto/internal
     2	/Users/tommy/go-workspace/src/google.golang.org/genproto/googleapis
     3	/Users/tommy/go-workspace/src/google.golang.org/genproto/.git
     4	/Users/tommy/go-workspace/src/google.golang.org/genproto/protobuf
     5	/Users/tommy/go-workspace/src/github.com/golang/protobuf
     6	/Users/tommy/go-workspace/src/github.com/gogo/protobuf
```

And also, you can cd to that directory by choosing line number

```bash
function cdgo() {
  r=$(findgo $1)
  echo $r
  printf 'cd to ? > '
  read cdto
  p=$(echo $r | sed -n "${cdto}p" | awk '{ print $2 }')
  cd $p
}
```

```console
➜  protobuf git:(master) cdgo proto
     1	/Users/tommy/go-workspace/src/google.golang.org/genproto/internal
     2	/Users/tommy/go-workspace/src/google.golang.org/genproto/googleapis
     3	/Users/tommy/go-workspace/src/google.golang.org/genproto/.git
     4	/Users/tommy/go-workspace/src/google.golang.org/genproto/protobuf
     5	/Users/tommy/go-workspace/src/github.com/golang/protobuf
     6	/Users/tommy/go-workspace/src/github.com/gogo/protobuf
cd to ? > 1
➜  internal git:(master)
```

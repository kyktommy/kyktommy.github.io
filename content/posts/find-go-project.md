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
  find $GOPATH/src -mindepth 3 -maxdepth 3 -type d -exec ls -ld "{}" \; | grep $1 | awk '{ print $9 }'
}
```

outputs:

```console

$ findgo proto

/Users/tommy/go-workspace/src/google.golang.org/genproto/internal
/Users/tommy/go-workspace/src/google.golang.org/genproto/googleapis
/Users/tommy/go-workspace/src/google.golang.org/genproto/.git
/Users/tommy/go-workspace/src/google.golang.org/genproto/protobuf
/Users/tommy/go-workspace/src/github.com/golang/protobuf
/Users/tommy/go-workspace/src/github.com/gogo/protobuf

```

TODO: cd to that directory...

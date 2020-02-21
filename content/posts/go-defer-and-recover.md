+++
title = "Go Defer And Recover"
date = 2020-02-21T21:55:25+08:00
tags = ["go"]
categories = ["go"]
draft = false
+++

Go defer is LIFO. `defer` function will be executed even after `panic`. So put `recover` inside `defer`.

```go
package main

import (
  "fmt"
  "time"
)

func main() {
  defer func() {
    fmt.Println("main defer")
  }()

  go func() {
    defer func() {
      if err := recover(); err != nil {
        fmt.Println("recover", err)
      }
    }()
    panic("panic here")
  }()

  time.Sleep(1 \* time.Second)
  fmt.Println("end")
}
```

output:

```
recover panic here
end
main defer
```
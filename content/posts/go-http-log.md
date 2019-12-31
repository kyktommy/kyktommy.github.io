+++
title = "Go Http Log"
date = 2019-12-31T19:21:43+08:00
tags = ["go"]
categories = ["go"]
draft = false
+++

We need a logger for every routes, so made a simple http log middleware. Need to replace writer to custom one, and also take care of reading body.

```go
package main

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"strings"
)

type bodyLogWriter struct {
	http.ResponseWriter
	body *bytes.Buffer
}

func (w bodyLogWriter) Write(b []byte) (int, error) {
	w.body.Write(b)
	return w.ResponseWriter.Write(b)
}

func main() {

	httpLog := func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// copy buffer from request
			var sb bytes.Buffer
			io.Copy(&sb, r.Body)

			// assign back to request body
			r.Body = ioutil.NopCloser(strings.NewReader(sb.String()))

			// create logger writer
			blw := &bodyLogWriter{
				body:           bytes.NewBufferString(""),
				ResponseWriter: w,
			}

			// call next route
			next.ServeHTTP(blw, r)

			// print out
			fmt.Printf("url: %s\nrequest params: %s \nresponse data: %s\n\n", r.URL, sb.String(), blw.body.String())
		})
	}

	// route return what body has
	route := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var sb bytes.Buffer
		io.Copy(&sb, r.Body)
		w.Header().Set("hello", "world")
		w.Write(sb.Bytes())
	})

	http.Handle("/foo", httpLog(route))

	http.ListenAndServe(":8080", nil)
}
```

outputs

```console

server:
➜  httpresp go run server.go
url: /foo
request params: {"key1":"value1", "key2":"value2"}
response data: {"key1":"value1", "key2":"value2"}

client:

➜  httpresp curl -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST http://localhost:8080/foo -i
HTTP/1.1 200 OK
Hello: world
Date: Tue, 31 Dec 2019 11:19:58 GMT
Content-Length: 34
Content-Type: text/plain; charset=utf-8

{"key1":"value1", "key2":"value2"}%

```

References:

- [gin log middleware](https://stackoverflow.com/a/38548555)
- [interface playground](https://play.golang.org/p/Tt0V99lHPMX)

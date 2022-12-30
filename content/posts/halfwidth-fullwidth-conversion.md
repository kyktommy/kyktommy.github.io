+++
title = "Halfwidth Fullwidth Conversion"
date = 2022-12-30T20:02:35+08:00
tags = [""]
categories = [""]
draft = false
+++

全形半形轉換

```js

function half2full(str) {
  let len = str.length;
  let res = [];
  for (let i = 0; i < len; i++) {
    let c = str.charCodeAt(i);
    if (c >= 0x21 && c <= 0x7e) {
      res.push(String.fromCharCode(c + 65248));
    } else {
      res.push(str[i]);
    }
  }
  return res.join('');
}

function full2half(str) {
  let len = str.length;
  let res = [];
  for (let i = 0; i < len; i++) {
    let c = str.charCodeAt(i);
    if (c - 65248 >= 0x21 && c - 65248 <= 0x7e) {
      res.push(String.fromCharCode(c - 65248));
    } else {
      res.push(str[i]);
    }
  }
  return res.join('');
}
```

reference: [https://blog.miniasp.com/post/2019/01/02/Common-Regex-patterns-for-Unicode-characters](https://blog.miniasp.com/post/2019/01/02/Common-Regex-patterns-for-Unicode-characters)

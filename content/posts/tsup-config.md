+++
title = "Tsup Config"
date = 2024-10-22T11:33:35+08:00
tags = ["typescript", "tsup"]
categories = ["typescript", "javascript"]
+++

Configure tsup to build typescript library

```json

// package.json

{
  "script": {
    "build": "tsup --out-dir dist"
  },
  "tsup": {
    "clean": true,
    "sourcemap": false,
    "dts": true,
    "minify": true,
    "target": "ES2020",
    "format": [
      "esm",
      "cjs"
    ],
    "entry": [
      "src/index.ts"
    ]
  },
}


```

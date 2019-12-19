+++
title = "Rust Read Write File"
date = 2019-12-19T23:35:06+08:00
tags = ["rust"]
categories = ["rust"]
draft = false
+++

```rust
use std::fs;

fn main() {
  let data = "test data";

  // write file
  let w = fs::write("tmp.txt", data);
  match w {
    Ok(()) => println!("write success"),
    Err(err) => panic!("write fail {:?}", err),
  };

  // read file
  let r = fs::read_to_string("tmp.txt");
  let r = match r {
    Ok(content) => content,
    Err(err) => panic!("read fail {:?}", err),
  };
  println!("{}", r);
}
```

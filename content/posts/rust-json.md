+++
title = "Rust Json"
date = 2019-12-18T23:29:48+08:00
tags = ["rust"]
categories = ["rust"]
draft = false
+++

Rust serialize, deserialize json use [serde](https://serde.rs).

---

cargo.toml

```
[dependencies]
serde = "0.9"
serde_json = "0.9"
serde_derive = "0.9"
```

main.rs

```rust
extern crate serde;
extern crate serde_json;

#[macro_use] extern crate serde_derive;

#[derive(Serialize, Deserialize, Debug)]
struct Response {
  code: u32,
  success: bool,
  payload: Payload,
}

#[derive(Serialize, Deserialize, Debug)]
struct Payload {
  length: u32,
  items: Vec<String>,
}

fn main() {
  let data = r#"
  {
      "code": 200,
      "success": true,
      "payload": {
          "length": 123,
          "items": ["apple", "orange"]
      }
  }
  "#;

  // deserialize
  let resp: Response = serde_json::from_str(&data).unwrap();
  println!("resp: {:?}", resp);

  // serialize
  let resp_json = serde_json::to_string(&resp).unwrap();
  println!("json: {}", resp_json);
}
```

output

```
resp: Response { code: 200, success: true, payload: Payload { length: 123, items: ["apple", "orange"] } }
json: {"code":200,"success":true,"payload":{"length":123,"items":["apple","orange"]}}
```

+++
title = "Expressjs Multer File Upload"
date = 2021-01-31T21:08:24+08:00
tags = ["js"]
categories = ["js"]
draft = false
+++

[Expressjs](https://github.com/expressjs/express) + [Multer](https://github.com/expressjs/multer) for file upload.

### Usages:

`multer({ limits, fileFilter, storage })` creates Multer object for reusable in different requset handlers.

- `limits` limit fileSize, fieldName, etc...
- `fileFilter` custom file validation
- `storage` disk / memory / custom storage transform ([s3)

`multer().array('photos', 2)` creates request handler for different routes.

- `single` one file upload, get by `req.file`
- `array` multiple files upload, get by `req.files`
- `fields` multiple field for files upload, get by `req.files[<fieldName>][0]`


### Example

{{< gist kyktommy ccbd0b2b8dd00f2ace5e7585bf80fe94 >}}
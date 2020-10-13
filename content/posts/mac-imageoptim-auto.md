+++
title = "Mac Imageoptim Auto"
date = 2020-10-13T13:00:39+08:00
tags = ["mac"]
categories = ["mac"]
draft = false
+++

I want to automatically convert pdf to jpg, and compress jpg.  

First, need to install [ImageOptim](https://imageoptim.com/mac), and put in `Application` folder.

Then install [ImageOptim-CLI](https://github.com/JamieMason/ImageOptim-CLI) to run ImageOptim in command line.

```

# convert pdf to jpg
sips --resampleWidth 1024 -s format jpeg *.pdf --out dist/

# compress all jpg in dist folder
imageoptim dist

```
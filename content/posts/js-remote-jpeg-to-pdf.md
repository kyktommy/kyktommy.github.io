+++
title = "Js Remote Jpeg to Pdf"
date = 2024-09-16T18:46:49+08:00
tags = ["js", "nodejs"]
categories = ["js"]
+++

### installation

1. sharp
1. image-to-pdf
1. image-size

```typescript
import sharp from 'sharp'
import imgToPDF from "image-to-pdf"
import imageSize from "image-size"

const imagePath = './1.jpg'
const pdfPath = './1.pdf'

const imageBuffer = await (await request.get(url)).body()
const jpgBuffer = await sharp(imageBuffer).jpeg({ mozjpeg: true }).toBuffer()
fs.writeFileSync(imagePath, jpgBuffer)

const images = [imagePath]
const size = imageSize(imagePath)
imgToPDF(files, [size.width, size.height]).pipe(
  fs.createWriteStream(pdfPath)
);
```


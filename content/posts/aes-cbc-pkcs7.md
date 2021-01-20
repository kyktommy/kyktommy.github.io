+++
title = "Aes Cbc Pkcs7"
date = 2021-01-20T22:24:28+08:00
tags = ["golang", "js"]
categories = [""]
draft = false
+++

Logic: 
- sha256 key and iv
- AES encryption
- CBC mode
- PKCS7 padding

Versions:
- [golang version](#golang-version)
- [javascript version](#javascript-version)

### golang version

```golang

package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/sha256"
	"fmt"
)

func PKCS7Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func PKCS7UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}

func encrypt(data, key, iv []byte) []byte {
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}
	blockSize := block.BlockSize()
	data = PKCS7Padding(data, blockSize)
	mode := cipher.NewCBCEncrypter(block, iv)
	mode.CryptBlocks(data, data)
	return data
}

func decrypt(data, key, iv []byte) []byte {
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}
	mode := cipher.NewCBCDecrypter(block, iv)
	mode.CryptBlocks(data, data)
	data = PKCS7UnPadding(data)
	return data
}

func main() {
	data := []byte("123456")
	hash := sha256.New()
	hash.Write([]byte("123456"))
	key := hash.Sum(nil)
	hash.Reset()
	hash.Write([]byte("654321"))
	iv := hash.Sum(nil)[:16]
	fmt.Printf("key: %x, iv: %x\n", key, iv)

	encrypted := encrypt(data, key, iv)
	fmt.Printf("encrypted: %x\n", encrypted)

	decrypted := decrypt(encrypted, key, iv)
	fmt.Printf("decrypted: %s\n", string(decrypted))
}

```

### javascript version

```javascript

var Cryptojs = require("crypto-js");

var key = Cryptojs.SHA256("123456").toString();
var iv = Cryptojs.SHA256("654321").toString().substring(0, 32);

console.log({ key, iv });

var encryptCipher = Cryptojs.AES.encrypt(
  "123456",
  Cryptojs.enc.Hex.parse(key),
  {
    iv: Cryptojs.enc.Hex.parse(iv),
    mode: Cryptojs.mode.CBC,
    padding: Cryptojs.pad.Pkcs7,
  }
);

const encrypted = encryptCipher.toString(Cryptojs.format.Hex);

console.log({ encrypted });

var decryptCipher = Cryptojs.AES.decrypt(
  encryptCipher.toString(),
  Cryptojs.enc.Hex.parse(key),
  {
    iv: Cryptojs.enc.Hex.parse(iv),
    mode: Cryptojs.mode.CBC,
    padding: Cryptojs.pad.Pkcs7,
  }
);

const decrypted = decryptCipher.toString(Cryptojs.enc.Utf8);

console.log({ decrypted });


```
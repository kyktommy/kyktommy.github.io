+++
title = "Go Cap Problem"
date = 2020-01-09T23:59:01+08:00
tags = ["go"]
categories = ["go"]
draft = false
+++

golang cap

> The capacity of a slice is the number of elements in the underlying array, counting from the first element in the slice.

If we append item to a slice that over the capacity, it will return the new array. But if we append item to a slice within capacity, it will change the orginal one.

The following code shows underCap changes the input array.

---

```go

func overCap(a []int) []int {
	fmt.Printf("before over cap addr: %p\n", a)
	a = append(a[:0], 7, 7, 7, 7)
	fmt.Printf("after over cap addr: %p\n", a)
	return a
}

func underCap(a []int) []int {
	fmt.Printf("before under cap addr: %p\n", a)
	a = append(a[:0], 7, 7)
	fmt.Printf("after under cap addr: %p\n", a)
	return a
}

func main() {
	a := []int{1, 2, 3}

	b := overCap(a)
	fmt.Println(a, "->", b)

	fmt.Println("---")


	c := underCap(a)
	fmt.Println(a, "->", c)
}

```

outputs:

```
before over cap addr: 0x40e020
after over cap addr: 0x456020
[1 2 3] -> [7 7 7 7]
---
before under cap addr: 0x40e020
after under cap addr: 0x40e020
[7 7 3] -> [7 7]
```

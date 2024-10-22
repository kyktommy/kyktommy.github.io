+++
title = "Css Z Index.md"
date = 2024-10-22T13:08:57+08:00
tags = ["css"]
categories = ["css"]
+++

notes:

- z-index need to add position `relative` or above
- z-index calculate from its parent that with `z-index`
- z-index auto do not measure

edge case 1:

- layer 1 (z-index: 2), layer 1-1 (z-index: 99)
- layer 2 (z-index: 1), layer 2-1 (z-index: 99999)
- result: layer 1-1 shows on top

edge case 2:

- layer 1 (z-index: 2), layer 1-1 (z-index: 99)
- layer 2 (z-index: auto), layer 2-1 (z-index: 99999)
- result: layer 2-1 shows on top

---

test index.html

{{< gist kyktommy a57a217b8feb712d97b996926fcf7740 >}}

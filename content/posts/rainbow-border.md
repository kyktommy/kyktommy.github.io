+++
title = "Rainbow Border"
date = 2021-02-11T20:32:28+08:00
tags = ["css"]
categories = ["css"]
draft = false
+++

https://codepen.io/kyktommy/pen/bGBBBZL

- Outside box fill with rainbow gradient background
- Inside box fill with solid background color

```css

/* .box > .inner */

.box {
  width: 100px;
  height: 100px;
  padding: 3px;
  box-sizing: border-box;
  background-image: linear-gradient(
    to bottom right,
    #b827fc 0%, 
    #2c90fc 25%, 
    #b8fd33 50%, 
    #fec837 75%, 
    #fd1892 100%
  );
}

.inner {
  width: 100%;
  height: 100%;
  background: black;
}

```

---

New css version (safari not supporting)

https://codepen.io/unnegative/pen/dVwYBq
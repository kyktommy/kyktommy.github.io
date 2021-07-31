+++
title = "Cra Import Sort"
date = 2021-07-31T15:33:29+08:00
tags = ["react"]
categories = ["react"]
draft = false
+++

### Target

- `import path alias`, relative path is not good for refactoring
- `import sorting` across the team, everyone got same import order
- eslint fix, vscode intelligence fix

### Result

```
// sort import
import React, { useEffect, useState } from 'react'

// alias import path
import MyButton from '@/components/MyButton'
```


### Install

- craco
- eslint-plugin-simple-import-sort
- eslint-import-resolver-alias

### Setup

craco.config.js

- map @ to all folder in src

```
const path = require('path')

module.exports = {
  webpack: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  }
}

```

eslintrc.js

- import plugin
- the rule is used for auto fix and error highlight in editor

```
{
  plugins: ['simple-import-sort', 'react', 'prettier'],
  rules: {
    'simple-import-sort/imports': 'error'
  },
  settings: {
    'import/resolver': {
      alias: {
        map: [['@', './src']],
        extensions: ['.ts', '.js', '.jsx', '.json'],
      },
    },
  }
}

```

jsonconfig.json

- vscode can find reference in alias path and jsx

```
{
  "compilerOptions": {
    "jsx": "react",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "exclude": ["node_modules", "build"]
}
```

eslint auto fix all files

```
$ eslint ./src --ext .jsx,.js --fix
```

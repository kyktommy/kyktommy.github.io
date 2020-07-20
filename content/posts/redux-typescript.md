+++
title = "Redux Typescript"
date = 2020-07-20T19:46:45+08:00
tags = ["react", "redux", "typescript"]
categories = [""]
draft = false
+++

There are two library for redux,

1. [redux-toolkit](https://github.com/reduxjs/redux-toolkit)
  1. create a slice for reducer, action = reducer key name
1. [reduxsauce](https://github.com/jkeam/reduxsauce)
  1. normal createActions, createReducer

I recommend redux-toolkit, because it has better support for typescript.  
It restrict `PayloadAction<SOMETHING>` for action creator and reducer.  
But the downside is action must be binded to reducer.  
Must need to create new action for dispatch two actions.  

{{< gist kyktommy 9e6fea3fd3c4d26464f477156b1500a6 >}}
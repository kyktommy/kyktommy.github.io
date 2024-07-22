+++
title = "React Query GcTime StaleTime"
date = 2024-07-22T17:39:43+08:00
tags = ["react", "react-query"]
categories = ["react"]
+++

react query `gcTime / cacheTime` vs `staleTime`

- when a component use `useQuery` with key, it start fetching and loading
- gcTime: start this timer after all components unmount (inactive)
- staleTime: start this timer after fetch complete, indicate whether makes api call or not
- case 1: when `gcTime=5000, staleTime <= gcTime`
    - within 5s, this component re-mount will use the same data as initial, and fetching api in background, and update the cache data
    - after 5s, this component re-mount, it start fetching and loading again cuz cache data has been gc, needs to refetching to get the data
- case 2: when `gcTime=5000, staleTime=Infinity`
    - this component use the data and keep data as fresh, will not fetch forever

#!/bin/bash

# build
hugo -t hugo-theme-cactus-plus

# page master
echo -e "\033[0;32mDeploying posts to GitHub...\033[0m"
cd public
git add .
msg="rebuilding site `date`"
git commit -m "$msg"
git push -f origin HEAD:master
cd ..

# page core
echo -e "\033[0;32mDeploying core to GitHub...\033[0m"
git add .
git commit -m "update blog"
git push -f origin core

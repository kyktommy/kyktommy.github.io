#!/bin/bash

echo -e "\033[0;32mDeploying posts to GitHub...\033[0m"

# build
hugo -t hugo-theme-cactus-plus

# page master
cd public
git add .
msg="rebuilding site `date`"
git commit -m "$msg"
git push -f origin master
cd ..

# page core
echo -e "\033[0;32mDeploying core to GitHub...\033[0m"
git add .
git commit -m "update blog setting `date`"
git push -f origin core

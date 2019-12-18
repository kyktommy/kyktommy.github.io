#!/bin/bash

echo -e "\033[0;32mDeploying core to GitHub...\033[0m"

git add .
git commit -m "update blog setting `date`"
git push origin core

echo -e "\033[0;32mDeploying posts to GitHub...\033[0m"

# Build the project.
hugo -t hugo-theme-cactus-plus
cd public
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
git push origin master
cd ..

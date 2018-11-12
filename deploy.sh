#!/bin/bash

echo -e "\033[0;32mDeploying core to GitHub...\033[0m"

git add .

git commit -m 'udpate blog setting'

git push origin core

echo -e "\033[0;32mDeploying posts to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

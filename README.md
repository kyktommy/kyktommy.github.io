# instal hugo
brew install hugo

# get submodule
git submodule update --init --recursive

# new posts
hugo new posts/new-post-name.md

# start test server
./start.sh

# deploy
./deploy.sh
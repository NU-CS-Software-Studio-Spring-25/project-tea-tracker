#!/bin/bash
git config core.hooksPath githooks
chmod +x githooks/*
echo "Git hooks directory set to ./githooks"

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-commit script
ln -s ../../scripts/pre-commit.bash $GIT_DIR/hooks/pre-commit
ln -s ../../scripts/pre-push.bash $GIT_DIR/hooks/pre-push
echo "Done!"
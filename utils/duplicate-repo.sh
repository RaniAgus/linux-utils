#!/bin/sh

set -e

if [ -z "$2" ]; then
    echo "Usage: $0 <dest_repo> <src_repo>"
    exit 1
fi

dest=${1:?}
src=$(echo ${2:?} | cut -d'/' -f2)

gh repo clone $2
cd "$src" || exit
git remote add fork "https://github.com/${dest}.git"
git branch "$src"
git checkout "$src"
git config user.email "aguseranieri@gmail.com"
git push -u fork "$src"

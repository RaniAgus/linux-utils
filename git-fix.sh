#!/bin/bash

for d in ./*/;
do
 (
 cd "$d" || exit
 git diff --name-only | xargs -I{} chmod 644 "{}"
 )
done

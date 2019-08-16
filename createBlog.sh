#!/bin/bash
HEXO="/home/pi/myProject/myBlogResource/node_modules/hexo/node_modules/.bin"

MYBLOG="/home/pi/myProject/myBlogResource"

hexo="$HEXO/hexo"

$hexo new "$1"

wait

mv "$MYBLOG/source/_posts/$1.md" .

#!/bin/bash
HEXO="/home/littleboy/myProject/myBlogResource/node_modules/hexo/node_modules/.bin"

MYBLOG="/home/littleboy/myProject/myBlogResource"

hexo="$HEXO/hexo"

$hexo new "$1"

wait

mv "$MYBLOG/source/_posts/$1.md" .

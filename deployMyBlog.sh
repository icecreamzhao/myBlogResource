#!/bin/bash
HEXO="/home/littleboy/myProject/myBlogResource/node_modules/hexo/bin"

MYBLOG="/home/littleboy/myProject/myBlogResource"

hexo="$HEXO/hexo"

cd $MYBLOG
$hexo deploy
cd -

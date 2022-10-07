#!/bin/bash
HEXO="/home/littleboy/myProject/myBlogResource/node_modules/hexo-cli/bin"

MYBLOG="/home/littleboy/myProject/myBlogResource"

hexo="$HEXO/hexo"

cd $MYBLOG
$hexo clean
wait
$hexo douban -b
$hexo g
wait
$hexo s &
cd -

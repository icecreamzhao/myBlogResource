#!/bin/bash
HEXO="/home/pi/myProject/myBlogResource/node_modules/hexo/node_modules/.bin"

MYBLOG="/home/pi/myProject/myBlogResource"

hexo="$HEXO/hexo"

cd $MYBLOG
$hexo clean
wait
$hexo g
wait
$hexo s &
cd -

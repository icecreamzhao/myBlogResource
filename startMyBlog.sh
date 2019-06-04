#!/bin/bash
HEXO="/home/littleboy/myProject/myBlogResource/node_modules/hexo/node_modules/.bin"

MYBLOG="/home/littleboy/myProject/myBlogResource"

hexo="sh $HEXO/hexo"

cd $MYBLOG
$hexo clean
wait
$hexo g
wait
$hexo s &
cd -

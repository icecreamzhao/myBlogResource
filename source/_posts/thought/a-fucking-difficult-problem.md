---
title: 一个非常操蛋的难题
date: 2019-12-07 17:36:15
categories:
- 随笔
tags:
- 随笔
- 经历
---

# 问题描述

前段时间, 工作方面遇到了一些问题, 具体情况是这样的:

前端和后端建立长连接(websocket), 但是有的时候会出现客户端非常卡, 然后会造成客户丢分, 甚至会造成负分的情况。我就开始找程序的逻辑, 怎么找都找不到问题。

# 解决经历

后来我发现出问题的时间很有规律, 都是发生在数据库自动备份的时间, 那么其实找到原因, 解决办法就有了, 直接取消自动备份, 完事!
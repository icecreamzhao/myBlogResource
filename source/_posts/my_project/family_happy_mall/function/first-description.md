---
title: 商城开发笔记 -- 开篇
date: 2022-11-07 13:59:28
categories:
- 开发笔记
- 家家乐商城
- 开篇
tags:
- 商城开发
mermaid: true
---

本系列的[前身](/my_project/shopping_mall/Dependence_and_configuration/Shopping-mall-developNote-framework.html)由于时间久远, 其中涉及到的技术栈以及架构早已过时, 由此才打算开一个新坑。尤其是拜读过周大大的《凤凰架构》之后, 对于架构有了一个全新的认识, 所以也打算按照凤凰架构中的章节, 分别使用单体架构、 微服务(spring cloud)、微服务(kubernetes)、服务网格(istio)这几种架构都实现一遍。

# 架构

我理解的架构是分层次的, 先从最底层开始讨论。

## 单体架构

最底层的架构指的是代码分层架构(软件架构), 类似mvc架构, mvvm架构[^1]等, 可以使得软件工程师轻松的划分出代码逻辑。

[^1]: <div style="display: flex;">
    <center><img src="/images/my-project/family-happy-mall/MVC-Process.svg.png" alt="mvc架构示意图">mvc架构示意图</center>
    <center><img src="/images/my-project/family-happy-mall/MVVMPattern.png" alt="mvvm架构示意图">mvvm架构示意图</center>
</div>

我打算在本项目中探索DDD架构(伪)的落地方式, 
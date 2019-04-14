---
title: Linux守护进程
date: 2019-04-14 09:04:17
categories:
- computer-operation
- linux
tags:
- linux
---

转自[【Linux】守护进程以及实现一个守护进程](https://blog.csdn.net/wenqiang1208/article/details/71550599)

# 什么是守护进程

守护进程也称为精灵进程，是运行在后台进程的一种特殊进程。它独立于控制终端并且周期性地执行某种任务或等待处理某些发生的事件。 
1. 脱离于控制终端并且在后台运行 
2. 不受用户登录注销的影响，它们一直在运行着 
Linux大多数服务器就是用守护进程实现的，例如：Internet服务器inetd，Web服务器httpd

查看系统中的守护进程：使用命令`ps axj` 
凡是TPGID一栏中写着-1的都是没有控制终端的进程，也就是守护进程。 
在COMMAND一列中用 [ ]括起来的名字表示内核线程，这些线程在内核里创建，没有用户空间代码，通常采用K开头的，表示Kernel

![linux进程](/images/linux/computer-operation/linux_daemo.jpg)

# 实现一个守护进程

* 屏蔽一些控制终端信号

```c
signal(SIGTTOU, SIG_IGN)
signal(SIGTTIN, SIG_IGN)
signal(SIGTSTP, SIG_IGN)
signal(SIGNUP,  SIG_IGN)
```

* 调用fork, 父进程退出

```c
// 调用fork函数, 父进程退出
pid = fork();
if (pid < 0) {
    printf("error fork");
} else if (pid > 0) {
    // father
    exit(0);
}
```

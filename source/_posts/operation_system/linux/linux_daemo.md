---
title: Linux守护进程
date: 2019-04-14 09:04:17
categories:
- 运维
- linux
tags:
- linux
---

转自[【Linux】守护进程以及实现一个守护进程](https://blog.csdn.net/wenqiang1208/article/details/71550599)

其他关于守护进程的博客:

[Linux系统下创建守护进程（Daemon）](https://blog.csdn.net/linkedin_35878439/article/details/81288889)

<!--more-->

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

> 这是为了防止守护进程在没有运行起来前, 控制终端收到干扰退出或挂起。

```c
signal(SIGTTOU, SIG_IGN)
signal(SIGTTIN, SIG_IGN)
signal(SIGTSTP, SIG_IGN)
signal(SIGNUP,  SIG_IGN)
```

* 调用fork, 父进程退出

> 保证子进程不是一个组长进程, 方法是在进程中调用fork()使父进程终止, 让守护进程在子进程中后台执行。

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

* setsid创建一个新会话

```c
SYNOPSIS
    
    #include <unistd.h>

    pid_t setsid(void);

DESCRIPTION

    setsid() creates a new session if the calling process is not a process group leader. The calling process is the leader of the new session, the process group leader of the new process group, and has no controlling tty. The process group ID and session ID of the calling process are set to the PID of the calling process. The calling process will be the only process in this new process group and in this new session.
```

该函数返回值: 调用成功返回新创建的Session的id(就是当前进程的id), 出错返回-1.

注意: 当调用该函数之前, 当前进程不能是进程组的组长, 否则返回-1

所以: 要保证当前进程不是进程组的组长, 先fork创建一个子进程, 这样保证了子进程不可能是该组进程 的第一个进程, 再调用setsid。

成功调用setsid函数的结果

    * 创建一个新的Session, 当前进程成为Session Leader, 当前进程id就是Session的id
    * 创建一个新的进程组, 当前进程成为进程组的Leader, 当前进程id就是进程组的id
    * 如果当前进程原本有一个控制终端, 则它失去控制终端, 成为一个没有控制终端的进程


* 禁止进程重新打开控制终端

现在, 进程已经成为无终端的会话组长, 但它可以重新申请打开一个控制终端。可以通过使进程不再成为会话组长来禁止进程重新打开控制终端, 采用的方法是再次创建一个子进程, 示例代码如下:

```c
if (pid=fork()) { //父进程
    exit(0);      //结束第一子进程, 第二子进程继续(第二子进程不再是会话组长)
}
```

* 关闭打开的文件描述符



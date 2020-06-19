---
title: 《跟我一起写makefile (一)》摘抄
date: 2019-06-02 08:16:53
categories:
- 笔记
- 跟我一起写makefile
tags:
- c++
- 笔记
- makefile
---

# 前言

之前转载了一篇关于[Makefile](/c_plus_plus_primer/tips/make/edit-makefile.html)的文章, 但是总感觉还是有一些东西没有搞明白, 偶然间看到了陈浩大神的专栏, 其中就有[关于Makefile的一系列的文章](https://blog.csdn.net/haoel/article/details/2886), 遂决定对这一系列的文章进行摘抄。
<!--more-->

# 概述

&emsp;&emsp;什么是 makefile? 或许很多 Windows 的程序远都不知道这个东西, 因为那些 Windows 的 IDE 都为你做了这个工作, 但我觉得要做一个好的和 professional 的程序员, makefile 还是要懂。这就好像现在有这么多的 HTML 编辑器, 但如果你想成为一个专业人士, 你还是要了解 HTML 标识的含义。特别在 Unix 下的软件编译, 你就不能不自己写 makefile 了, 会不会写 makefile, 也可以侧面说明了一个人是否具备完成大型工程的能力。

&emsp;&emsp;因为, makefile 关系到了整个工程的编译规则, 一个工程中的源文件不计其数, 其按类型, 功能, 模块分别放在若干个目录中, makefile 定义了一系列的规则来指定, 哪些文件需要先编译, 哪些文件需要后编译, 哪些文件需要重新编译, 甚至于进行更复杂的功能操作, 因为 makefile 就像一个 shell 脚本一样, 也可以执行操作系统的命令。

&emsp;&emsp;makefile 带来的好处就是——"自动化编译", 一旦写好, 只遇到一个 make 命令, 整个工程完全自动编译, 极大的提高了软件开发的效率。make 是一个命令工具, 是一个解释 makefile 中指令的命令工具, 一般来说, 大多数的 IDE 都有这个命令, 比如: Delphi 的 make, Visual C++ 的 nmake, Linux 下 GNU 的make。可见, makefile 都成为了一种在工程方面的的编译方法。

&emsp;&emsp;现在讲述如何写 makefile 的文章比较少, 这是我想写这篇文章的原因, 当然, 不同厂商的 make 各不相同, 也有不同的语法, 但其本质都是在"文件依赖性"上做文章, 这里, 我仅对 GNU 的 make 进行讲述, 我的环境是 RedHat Linux 8.0, make 的版本是3.80。毕竟这个 make 是应用最为广泛的, 而且它还是遵循于 IEEE 1003.2-1992 标准的(POSIX.2)。

&emsp;&emsp;在这篇文档中, 将以 C/C++ 的源码作为我们的基础, 所以必然涉及一些关于 C/C++ 的编译的知识, 相关于这方面的内容, 还请各位查看相关的编译器的文档。这里所默认的编译器是 UNIX 下的 GCC 和 CC。

# 关于程序的编译和链接

&emsp;&emsp;在此, 我想多说一些关于程序编译的一些规范和方法, 一般来说, 无论是 C, C++, 还是 pas, 首先要把源文件编译成中间代码文件, 在 Windows 下也就是 `.obj` 文件, UNIX 下是 `.o` 文件, 即Object File, 这个动作叫做编译(compile)。然后再把大量的 Object File 合成执行文件, 这个动作叫做链接(link)。

&emsp;&emsp;编译时, 编译器需要的是语法的正确, 函数与变量的声明的正确, 对于后者, 通常是你需要告诉编译器头文件的所在位置(头文件中应该只是声明, 而定义应该放在 C/C++ 文件中), 只要所有的语法正确, 编译器就可以编译出中间目标文件。一般来说, 每个源文件都应该对应与一个中间目标文件(O 文件或是 OBJ 文件)。

&emsp;&emsp;链接时, 主要是链接函数和全局变量, 所以, 我们可以使用这些中间目标文件(O 或 OBJ 文件)来链接我们的应用程序。链接器并不管函数所在的源文件, 只管函数的中间目标文件(Object File), 在大多数时候, 由于源文件太多, 编译生成的中间目标文件太多, 而在链接时需要明显地指出中间目标文件名, 这对于编译很不方便, 所以, 我们要给中间文件打个包, 在 Windows 下这种包叫做"库文件"(Library File), 也就是`.lib`文件, 在 UNIX 下是 Archive File, 也就是`.a`文件。

&emsp;&emsp;总结一下, 源文件首先会生成中间目标文件, 再由中间目标文件生成执行文件。在编译时, 编译器只检测语法和函数, 变量是否被声明。如果函数未被声明, 编译器会给出一个警告, 但可以生成 Object File。而在链接程序时, 链接器会在所有的 Object File 中找寻函数的实现, 如果找不到, 那就会报链接错误码(Linker Error)。在 VC 下, 这种错误一般是: Link 2001 错误, 意思是说, 链接器未能找到函数的实现, 需要指定函数的 Object File。

# Makefile 介绍

&emsp;&emsp;make 命令执行时, 需要一个 Makefile 文件, 以告诉 make 命令需要怎么样的去编译和链接程序。

首先, 我们用一个示例来说明 Makefile 的书写规则, 一边给大家一个感性认识。这个示例来源于 GNU 的 make 使用手册, 在这个示例中, 我们的工程有 8 个 C 文件, 和 3 个头文件, 我们要写一个 Makefile 来告诉 make 命令如何编译和链接这几个文件。我们的规则是:

1. 如果这个工程没有编译过, 那么我们的所有 C 文件都要编译并被链接。
2. 如果这个工程的某几个 C 文件被修改, 那么我们只编译被修改的 C 文件, 并链接目标程序。

&emsp;&emsp;只要我们的 Makefile 写得够好, 所有的这一切, 我们只用一个 make 命令就可以完成, make 命令会自动智能地根据当前文件的修改情况来确定哪些文件需要重编译, 从而自己编译所需要的文件和链接目标程序。

# 一、Makefile 的规则

在讲述这个 Makefile 之前, 还是让我们来粗略地看看 Makefile 的规则。

```
target ... : prerequisites ...
	command
	...
	...
```

target, 也就是一个目标文件, 可以是 Object File, 也可以是可执行文件, 还可以是一个标签(Label), 对于标签, 在后续的"伪目标"中会有叙述。

prerequisites 就是要生成 target 所需要的文件或是目标。

command 是 make 需要执行的命令(任意的 Shell 命令)。

&emsp;&emsp;这是一个文件的依赖关系, 也就是说, target 这一个或多个目标文件依赖于 prerequisites 中的文件, 其生成规则定义在 command 中。说白一点, prerequisites 中如果有一个以上的文件比 target 文件修改日期要新的话, command 所定义的命令就会被执行。这就是 Makefile 的规则, 也就是 Makefile 中最核心的内容。

# 二、一个示例

正如前面说的, 如果一个工程有 3 个头文件和 8 个 C 文件, 我们为了完成前面所述的那三个规则, 我们的 Makefile 应该是下面这个样子:

```
edit: main.o kbd.o command.o display.o /
      insert.o search.o files.o utils.o
	cc -o edit main.o kbd.o command.o display.o /
	insert.o search.o files.o utils.o

main.o : main.c defs.h
	cc -c main.c

kbd.o : kbd.c defs.h command.h
	cc -c kbd.c

command.o : command.c defs.h command.h
	cc -c command.c

display.o : display.c defs.h buffer.h
	cc -c display.c

insert.o : insert.c defs.h buffer.h
	cc -c insert.c

search.o : search.c defs.h buffer.h
	cc -c search.c

file.o : file.c defs.h buffer.h command.h
	cc -c files.c

utils.o : utils.c defs.h
	cc -c utils.c

clean :
	rm edit main.o kbd.o command.o display.o /
	   insert.o search.o file.o utils.o
```

&emsp;&emsp;反斜杠(/)是换行符的意思。这样比较便于 Makefile 的易读。我们可以把这个内容保存在文件为"Makefile" 或 "makefile"的文件中, 然后在该目录下直接输入命令"make"就可以生成执行文件 edit。如果要删除执行文件和所有的中间目标文件, 那么只要简单地执行"make clean"就可以了。

&emsp;&emsp;在这个 makefile 中, 目标文件(target)包含: 执行文件 edit 和中间目标文件(*.o), 依赖文件(prerequisites)就是冒号后面那些`.c`文件和`.h`文件。每一个`.o`文件都有一组依赖文件。依赖关系的实质上就是说明了目标文件是由那些文件生成的, 换言之, 目标文件是哪些文件更新的。

&emsp;&emsp;在定义好依赖关系后, 后续的哪一行定义了如何生成目标文件的操作系统命令, 一定要以一个 Tab 键作为开头。记住, make 兵部观命令是怎么工作的, 他只管执行所定义的命令。make 会比较 targets 文件和 prerequisites 文件的修改日期, 如果 prerequisites 文件的日期要比 targets 文件的日期新, 或者 target 不存在的话, 那么 make 就会执行后续定义的命令。

&emsp;&emsp;这里要说明一点的是, clean 不是一个文件, 他只不过是一个动作名字, 有点像 C 语言中的 label 一样, 其冒号后面什么也没有, 那么, make 就不会自动去找文件的依赖性, 也就不会自动执行其后所定义的命令。要执行其后的命令, 就要在 make 命令后明显的指出这个 label 的名字。这样的方法非常有用, 我们可以在一个 makefile 中定义不用的编译或是和编译无关的命令, 比如程序的打包, 备份等。

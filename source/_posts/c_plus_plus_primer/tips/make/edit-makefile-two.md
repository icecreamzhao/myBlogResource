---
title: 《跟我一起写makefile (二)》摘抄
date: 2019-06-03 09:26:13
categories:
- C/C++
- C++
- 积累
tags:
- C++
- makefile
---

# 三、make是如何工作的

在默认的方式下, 也就是我们只输入 make 命令。那么,

1. make 会在当前目录下找名字叫"Makefile" 或 "makefile"的文件
2. 如果找到, 它会找文件中的第一个目标文件(target), 在上面的例子中, 他会找到"edit"这个文件, 并把这个文件作为最终的目标文件。
3. 如果 edit 文件不存在, 或是 edit 所依赖的后面的 `.o` 文件的文件修改时间要比 edit 这个文件新, 那么, 他就会执行后面所定义的命令来生成 edit 文件。
4. 如果 edit 所依赖的 `.o` 文件也存在, 那么 make 命令会在当前文件中找目标为 `.o` 文件的依赖性, 如果找到则在根据那个规则生成 `.o` 文件。(有点像堆栈的过程)
5. 当然, 你的 C (或 cpp )文件和 H 文件是存在的啦, 于是 make 会生成 `.o` 文件, 然后再用 `.o` 文件声明 make 的终极任务, 也就是执行文件 edit 了。

<!--more-->

&emsp;&emsp;这就是整个 make 的依赖性, make 会一层又一层地去找文件的依赖关系, 直到最终编译出第一个目标文件。在找寻的过程中, 如果出现错误, 比如被依赖的文件找不到, 那么 make 会直接退出, 并报错, 而对于所定义的命令的错误, 或是编译不成功, make 根本不理。make 只管文件的依赖性, 即, 如果在我找了依赖关系之后, 冒号后面的文件还是不在, 那么对不起, 我就不工作啦。

&emsp;&emsp;通过上述分析, 我们知道, 像 clean 这种, 没有被第一个目标文件直接或间接地关联, 那么它后面定义的命令将不会被自动执行, 不过我们可以显示让 make 执行。即命令 `make clean`, 以此来清除所有的目标文件, 以便重编译。

&emsp;&emsp;如果整个工程已经被编译过了, 当我们修改了其中一个源文件, 比如 file.c, 那么根据依赖性, 我们的目标文件 file.o 会被重编译, 于是 file.o 的文件也是最新的了, 于是 file.o 的修改时间要比 edit 新, 所以 edit 也会被重新连接。

&emsp;&emsp;而如果我们改变了 command.h, 那么 kdb.o, command.o 和 files.o 也会被重编译, 并且 edit 会重新连接。

# 四、makefile 中使用变量

在上面的例子中, 先让我们看看 edit 的规则:

```
edit : main.o kdb.o command.o display.o \
       insert.o search.o files.o utils.o
	cc -o edit main.o kdb.o command.o display.o \
	insert.o search.o files.o utils.o
```

我们可以看到`.o`文件的字符串被重复了两次, 如果我们的工程需要加入一个新的`.o`文件, 那么我们需要在两个地方加这个文件。当然我们的 makefile 并不复杂, 但是如果 makefile 变得复杂了之后, 那么我们有可能会忘掉或搞不清在哪里加而导致编译失败。所以, 为了使 makefile 易维护, 在 makefile 中我们可以使用变量, makefile 的变量也就是一个字符串, 理解成 C 中的宏会更好。

我们可以声明一个`objects`来保存所有的 obj 文件:

```
objects = main.o kdb.o command.o display.o \
          insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)

main.o : main.c defs.h
	cc -c main.c

kdb.o : kdb.c defs.h command.h
	cc -c kdb.c

command.o : command.c defs.h command.h
	cc -c command.c

display.o : display.c defs.h buffer.h
	cc -c display.c

insert.o : insert.c defs.h buffer.h
	cc -c insert.c

files.o : files.c defs.h buffer.h command.h
	cc -c files.c

utils.o : utils.c defs.h
	cc -c utils.c

clean :
	rm edit $(objects)
```

如果有新的`.o`文件加入, 我们只需要简单的修改一下 objects 变量就可以了。

# 五、让 make 自动推导

GNU 的 make 很强大, 它可以自动推导文件以及文件依赖关系后面的命令, 于是我们就没必要去在每一个`.o`文件后都写上类似的命令, 因为我们的 make 会自动识别, 并自己推导命令。

只要 make 看到一个`.o`文件, 他就会自动的把`.c`文件加在依赖关系中, 如果 make 找到一个 whatever.o, 那么 whatever.c 就会是 whatever.o 的依赖文件。并且 cc -c whatever.c 也会被推导出来, 于是 makefile 变成了这样:

```
objects = main.o kdb.o command.o display.o \
          insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)

main.o : defs.h
kdb.o : defs.h command.h
command.o : defs.h command.h
display.o : defs.h command.h
insert.o : defs.h buffer.h
search.o : defs.h buffer.h
files.o : defs.h buffer.h command.h
utils.o : defs.h

.PHONY : clean
clean :
	rm edit $(objects)
```

这种方法, 也就是 make 的"隐晦规则", 上面的内容中, ".PHONY"表示, clean 是个伪目标文件。

# 七、清空目标文件的规则

每个 Makefile 中都应该写一个清空目标文件的规则, 一般的风格都是:

```
clean:
	rm edit $(objects)
```

更为稳健的做法是:

```
.PHONY : clean
clean:
	-rm edit $(objects)
```

rm 命令前加一个`-`的意思是也许某些文件出现问题, 但不要管, 继续做后面的事。当然 clean 的规则不要放到开头, 不然会被当成 make 的默认目标, 不成文的规矩是——"clean 从来都是放到文件的最后"。

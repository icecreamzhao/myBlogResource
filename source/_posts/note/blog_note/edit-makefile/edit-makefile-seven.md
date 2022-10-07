---
title: 《跟我一起写makefile (七)》摘抄
date: 2019-07-02 13:31:14
categories:
- 笔记
- 读博客笔记
- 跟我一起写makefile
tags:
- c++
- 笔记
- makefile
---

# 使用变量

&emsp;&emsp;在 Makefile 中定义的变量, 就像是 C/C++ 语言中的宏一样, 他代表一个文本字串, 在 Makefile 中执行的时候其会自动原模原样地展开在所使用的地方。其与 C/C++ 不同的是, 你可以在 Makefile 中改变其值。 在 Makefile 中, 变量可以使用在"目标", "依赖目标", "命令"或是 Makefile 的其他部分中。

&emap;&emsp;变量的命名可以包含字符, 数字, 下划线(可以是数字开头), 但不应该含有 `:`, `#`, `=` 或是空字符(空格, 回车等)。变量是大小写敏感的, 传统的 Makefile 的变量名是全大写的命令方式, 但更好的方式是使用大小写搭配的变量名。

<!--more-->

# 变量的基础

&emsp;&emsp;变量在声明时需要给予初值, 而在使用时给变量名加上`$`符号, 但最好使用小括号或是大括号把变量包括起来。如果要使用真实的`$`字符, 那么你需要用`$$`来表示。

变量可以用在许多地方, 如规则中的"目标", "依赖", "命令"以及新的变量中。先看一个例子:

```
objects = program.o foo.o utils.o
program : $(objects)
	cc -o program $(objects)

$(objects): defs.h
```

变量会在使用它的地方精确的展开, 就像 C/C++ 的宏一样, 例如:

```
foo = c
prog.o: prog.%(foo)
	$(foo)$(foo) -$(foo) prog.$(foo)
```

展开后得到:

```
prog.o : grop.c
	cc -c prog.c
```

给变量加上括号是为了更加安全的使用该变量。上面的例子中, 如果你不想给变量加上括号也是可以的, 但是还是加上更好一些。

# 变量中的变量

&emsp;&emsp;在定义变量的值时, 我们可以使用其他变量来构造变量的值, 在 Makefile 中有两种方式来在用变量的地方定义变量的值。

&emsp;&emsp;先看第一种方式, 也就是简单的使用 `=`, 值可以定义在文件的任意一处, 也就是说, 右侧的变量不一定是定义好的值, 如:

```
foo = $(bar)
bar = $(ugh)
ugh = Huh?

all:
	echo $(foo)
```
我们执行"make all"将会打出变量`$(foo)`的值是`Huh?`。

这个功能有好的地方也有不好的地方, 好的地方是可以把变量的真实值推到后面定义, 不好的地方是容易递归定义, 如:

```
CFlags = $(CFlags) -o
```

或:

```
A = $(B)
B = $(A)
```

这会让 make 陷入无限循环的变量展开过程中去。当然, 我们的 make 是有能力检测这样的定义, 并会报错。还有就是如果在变量中使用函数, 那么这种方式会让我们的 make 运行的非常慢, 更糟糕的是, 他会使用两个 make 的函数`wildcard`和`shell`发生不可预知的错误。因为你不知道这两个函数会被调用多少次。

为了避免上面的这两个情况, 我们可以使用 make 中的另一种用变量来定义变量的方法。这种方法使用的是`:=`操作符, 如:

```
x := foo
y := $(x) bar
x := later
```

这种方法, 前面的变量不能使用后面的定义的变量, 只能使用前面定义好的变量, 如果是这样:

```
y := $(x)bar
x :=foo
```

那么, y的值是 bar 而不是 foobar。

上面都是一些比较简单的变量使用了, 接着让我们来看一个复杂的例子,其中包括了 make 的函数, 条件表达式和一个系统 MAKELEVEL 的使用:

```
ifeq (0, $(MAKELEVEL))
cur-dir   := $(shell pwd)
whoami    := $(shell whoami)
host-type := $(shell arch)
MAKE := ${MAKE} host-type=${host-type} whoami=${whoami}
endif
```

关于条件表达式和函数, 我们在后面再说, 对于系统变量 MAKELEVEL, 其意思是, 如果我们的 make 有一个嵌套执行的动作(参见前面的"嵌套使用make"), 那么, 这个变量会记录我们当前 makefile 的调用层数。

下面在介绍两个定义变量时我们需要知道的, 请先看一个例子, 如果我们要定义一个变量, 其值是一个空格, 那么我们可以这样来:

```
nullstring :=
space := $(nullString) # end of the line
```

nullString 是一个Empty 变量, 其中什么也没有, 而我们的 space 的值是一个空格。因为在操作符的右边是很难描述空格的, 这里采用的技术很管用, 先用一个 Empty 变量来标明变量的值开始了, 而后面采用 "#" 注释符来表示变量定义的终止, 这样, 我们可以定义出其值是一个空格的变量。请注意这里关于"#"的使用, 如果我们这样顶一个变量:

```
dir := /foo/bar     # directory to put the frobs in
```

dir 这个变量的值是"/foo/bar", 后面还跟了四个空格, 如果我们这样使用这个变量来指定别的目录那就完了。

还有一个比较有用的操作符是`?=`, 先看示例:

```
FOO ?= bar
```

其含义是, 如果 FOO 没有被定义过, 那么变量 FOO 的值就是 bar, 如果 FOO 先前被定义过, 那么这条语句什么也不做, 其等价于:

```
ifeq ($(origin FOO), undifined)
	FOO = bar
endif
```

# 变量高级用法

这里介绍两个变量的高级使用方法, 第一种是变量的替换。

我们可以替换变量中的共有的部分, 其格式是 `$(var:a=b)` 或是 `$(var:a=b)`, 其意思是, 把变量"var"中所有以a字串结尾的a替换成b字串。这里的结尾意思是空格或是结束符。

还是看一个示例吧:

```
foo := a.o b.o c.o
bar := $(foo:.o=.c)
```

这个示例中, 我们先定义了一个`$(foo)`变量, 而第二行的意思是把`$(foo)`中所有以`.o`字符串结尾的全部替换成`.c`, 所以我们的`$(bar)`的值是"a.c b.c c.c"。

另外一种变量替换的技术是以"静态模式"定义的, 如:

```
foo := a.o b.o c.o
bar := $(foo:%.o=%.c)
```

这依赖于被替换字符串中的有相同的模式, 模式中必须包含一个`%`字符, 这个例子同样让`foo`变成"a.c b.c c.c"。

第二种高级用法是 —— "把变量的值在当变量"。先看一个例子:

```
x = y
y = z
a := $($(x))
```

在这个例子中, a 是被解析为 `$(y)`, 也就是说最后 a 的结果是 z。注意, 这里 x 的值是 y, 而不是 `$(y)`。

我们还可以使用更多的层次:

```
x = y
y = z
z = u
a := $($($(x)))
```

这里的 a 的值是 u。

让我们再复杂一些, 使用"在变量定义中使用变量"的第一个方式, 来看例子:

```
x = $(y)
y = z
z = hello
a := $($(x))
```

这里`$($(x))`被替换成了`$($(y))`, 所以最后 x 的结果是`$(z)`, 也就是"hello"。

在复杂一些, 我们再加上函数:

```
x = variable1
variable2 := Hello
y = $(subst 1, 2, $(x))
z = y
a := $($($(z)))
```

这个例子中, `$($($(z)))` 扩展为 `$($(y))`, 再次被扩展为 `$($(subst 1, 2, $(x)))`, `$(x)`的值是variable1, `subst()` 函数将所有的 1 替换成了 2, 于是变成了`$(variable2)`, 最终的值是"hello"。

在这种方式中, 可以使用多个变量l来组成一个变量的名字, 然后再取其值:

```
first_second = hello
a = first
b = second
all = $($a_$b)
```

这样`all`先被扩展为`$(first_second)`, 最后的值是"hello"。

再来看看结合第一种技术的例子:

```
a_objects := a.o b.o c.o
1_objects := 1.o 2.o 3.o

sources := $($(a1)_objects:.o=.c)
```

如果`a1`的值是 a 的话, 那么sources的值是`a.c b.c c.c`, 如果`a1`的值是 1 的话, 那么sources的值是`1.c 2.c 3.c`。

再来看一个这种技术和"函数"与"条件语句"一同使用的句子:

```
ifdef do_sort
	func := sort
else
	func := strip
endif

bar := a b c d e f
foo := $($(func) $(bar))
```

这个示例中, 如果定义了"do_sort", 那么 `foo := $(sort a b c d e f)`, 于是 foo 的值就是排过序的, 如果没定义, 那么调用的是`strip`函数。

当然, 把变量的值在当变量这种技术, 同样可以用在操作符的左边:

```
dir = foo
$(dir)_sources := $(wildcard $(dir)/*.c)
define $(dir)_print
lpr $($(dir)_sources)
endef
```

这个例子定义了三个变量, `$(dir)`, `$(foo_sources)`和`$(foo_print)`。

# 追加变量值

我们可以使用`+=`操作符给变量追加值, 如:

```
objects = main.o foo.o bar.o util.o
objects += another.o
```

于是我们的`$(objects)`值变成了"main.o foo.o bar.o util.o"。

使用`+=`操作符, 可以模拟为下面这种例子:

```
objects = main.o foo.o bar.o util.o
objects := $(objects) another.o
```

所不同的是, 用 `+=` 更为简洁。

如果变量之前没有定义过, 那么`+=`会自动变成`=`, 如果前面有变量定义, 那么 `+=` 会继承于前次操作的赋值符。如果前一次的是`:=`, 那么`+=`会以`:=`作为其赋值符, 如:

```
variable := value
variable += more
```

等价于:

```
variable := value
variable := $(variable) more
```

但如果是这种情况:

```
variable = value
variable += more
```

由于前次的赋值符是`=`, 所以`+=`也会以`=`来赋值, 那么就不会发生变量的递归定义, 所以 make 会自动为我们解决这个问题, 我们不必担心这个问题。

# override 指示符

如果有变量是通过make的命令行参数设置的, 那么 Makefile 中对这个变量的复制会被忽略。如果你想在 Makefile 中设置这类参数的值, 那么, 你可以使用`override`指示符, 其语法是:

```
override <variable> = <value>
override <variable> := <value>
```

当然, 你还可以追加:

对于多行的变量定义, 我们用 define 指示符, 在 define 指示符前, 也同样可以使用 override 指示符, 如:

```
override define foo
bar
endef
```

---
title: flutter 的页面钩子
date: 2020-03-12 16:09:54
categories:
- 移动开发技巧/经验
- flutter
tags:
- flutter
---

# deactivate 方法

官方注释:

> Called when this object is removed from the tree.
The framework calls this method whenever it removes this [State] object
from the tree. In some cases, the framework will reinsert the [State]
object into another part of the tree (e.g., if the subtree containing this
[State] object is grafted from one location in the tree to another). If
that happens, the framework will ensure that it calls [build] to give the
[State] object a chance to adapt to its new location in the tree. If
the framework does reinsert this subtree, it will do so before the end of
the animation frame in which the subtree was removed from the tree. For
this reason, [State] objects can defer releasing most resources until the
framework calls their [dispose] method.
Subclasses should override this method to clean up any links between
this object and other elements in the tree (e.g. if you have provided an
ancestor with a pointer to a descendant's [RenderObject]).
If you override this, make sure to end your method with a call to
super.deactivate().

简单翻译一下:

当本页面被移出整个视图树后被自动调用。
framework 将本页面移出视图树后调用这个方法。在某些情况下, framework会将当前页面
重新插入到另一个树的某个部分(e.g. 如果子树包含的这个页面是从其他树中嫁接过来的)。
如果出现这种情况, framework会确保调用build()方法让该页面去适应在树中的新位置。如果
framework 重新插入了这个子树, 它将在从树中移出这个子树之前执行本方法。因为这个原
因, 当framework调用他们的dispose()方法的时候可以延迟释放更多资源。

也就是说只要是当页面不在当前视图中, 该方法就会被调用, 而且会调用该页面的build()方法。
注释中还提到了如果需要重载该方法, 请确保在方法最后调用 super.deactivate() 。

所以, 该方法其实是用来执行清理工作的, 

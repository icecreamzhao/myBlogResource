---
title: Java的File类的文件列表过滤
date: 2019-04-10 14:43:00
categories:
- Java
- 基础
tags:
- Java
- io
---

# 使用FilenameFilter来对文件列表进行过滤

可以通过File类的list()方法查看目录中的所有文件和文件夹, 并通过FilenameFiler来过滤文件列表。
<!--more-->
## 思路

实现FilenameFilter接口, 使用正则(Pattern)来对文件或文件夹名进行匹配。

代码:

```java
/**
 * 使用自定义的文件过滤器过滤指定文件夹内的文件列表并显示
 */
public class DirList {
    public static void main(String[] args) {
        String list[];
        File path = new File(".");
        if (args.length == 0) {
            list = path.list(); 
        } else {
            list = path.list(new DirFiler(args[0]));
        }
        // 通过Arrays的sorts方法对list列表进行排序
        Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
        for (String file : list) {
            System.out.println(file);
        }
    }
}

/**
 * 实现FilenameFiler接口实现自定义文件过滤器
 */
class DirFiler implements FilenameFilter {
    private Pattern mPattern;

    public DirFiler(String regex) {
        mPattern = Pattern.compile(regex);
    }

    @Override
    public boolean accept(File dir, String name) {
        return mPattern.matcher(name).matches();
    }
}
```

这里使用了内部类的形式来实现FilenameFiler接口, 那么我们其实可以试一下使用匿名内部类加lambda来替换内部类:

```java
public class DirListLambdaVersion {
    private FilenameFilter getMyFileFilter(String regex) {
        Pattern pattern = Pattern.complie(regex);
        return (dir, name) -> pattern.matcher(name).matches();
    }

    public static void main(String[] args) {
        String list[];
        File path = new File(".");
        if (args.length == 0) {
            list = path.list(); 
        } else {
            list = path.list(getMyFileFilter(args[0]));
        }
        // 通过Arrays的sorts方法对list列表进行排序
        Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
        for (String file : list) {
            System.out.println(file);
        }
    }
}
```

main方法中唯一的变化是将之前的内部类改成我们自己的方法, 我们这里使用lambda实现FilenameFiler接口, 一句话就可以替代之前好几行的内部类实现, 很方便有木有!

下面是直接将lambda表达式写到了main里:

```java
public class DirListLambdaVersion {
    public static void main(String[] args) {
        String list[];
        File path = new File(".");
        if (args.length == 0) {
            list = path.list();
        } else {
            Pattern pattern = Pattern.complie(args[0]);
            list = path.list((path, name) -> pattern.matcher(name).matches());
        }
        
        Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
        for (String file : list) {
            System.out.println(file);
        }
    }
}
```

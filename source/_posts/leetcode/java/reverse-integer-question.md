---
title: reverse-integer-question
date: 2019-05-17 22:20:51
categories:
- leetcode
- java
tags:
- leetcode
---

# 题目

给出一个 32 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

<!--more-->

示例1:

> 输入: 123
输出: 321

示例2:

>输入: -123
输出: -321

示例3:

>输入: 120
输出: 21

注意:

假设我们的环境只能存储得下 32 位的有符号整数，则其数值范围为 [−231,  231 − 1]。请根据这个假设，如果反转后整数溢出那么就返回 0。

# 解法

我最一开始的解法:

```java
public int reverse(int x) {
    // 存储是否是负数
    boolean isNegative = false;
    // 存储转为字符串
    String xString = "";
    if (x < 0) {
        isNegative = true;
    }
    xString = ((Integer)x).toString();
    // 判断如果是负数, 先将负数字符去掉
    if (isNegative) {
        xString = xString.substring(1);
    }
    char[] c = xString.toCharArray();

    // 循环字符串, 只需要循环这个字符串的长度的一半
    for (int i = 0; i < c.length / 2 ; ++i) {
        char temp = c[i];
        c[i] = c[c.length -1 - i];
        c[c.length - 1 - i] = temp;
    }

    xString = new String(c);
    int result = Integer.parseInt(xString);
    // 如果之前是负数, 则取负数
    if (isNegative) {
        result -= (result * 2);
    }
    return result;
}
```

当然是错的啦, 这里没有检测如果整数溢出怎么办, 所以这里需要加一个try{} catch(){}, 那么我的最后的答案是:

```java
public int reverse(int x) {
    boolean isNegative = false;
    String xString = "";
    if (x < 0) {
       isNegative = true;
    }
    xString = ((Integer)x).toString();
    if (isNegative) {
        xString = xString.substring(1);
    }
    char[] c = xString.toCharArray();

    for (int i = 0; i < c.length / 2 ; ++i) {
        char temp = c[i];
        c[i] = c[c.length -1 - i];
        c[c.length - 1 - i] = temp;
    }
    xString = new String(c);
    int result = 0;
    try {
        result = Integer.parseInt(xString);
        if (isNegative) {
            result -= (result * 2);
        }
    } catch (NumberFormatException e) {
      return 0;
    }
    return result;
}
```

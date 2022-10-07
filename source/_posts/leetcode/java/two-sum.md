---
title: two sum
date: 2019-03-17 23:50:38
categories:
- 做题
- java
tags:
- leetcode
---

# 题目

给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。
你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素。
<!--more-->
示例:
> 给定 nums = [2, 7, 11, 15], target = 9
因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]

# 解法
我最一开始的解法:

```java
public int twoSum(int[] sums, int target) {
    // 由于题目中说明了每种输入只会对应一个答案, 所以我这里直接将结果限定为两个长度
    int[] result = new int[2];

    for (int i = 0; i != sums.length; ++i) {
        for (int j = 0; j != sums.length; ++j) {
            if (sums[i] + sums[j] == target) {
                result[0] = i;
                result[1] = j;
            }
        }
    }
    return result;
}
```

当然是错的...首先j不应该从0开始, 应该从1开始, 准确的说应该是(i + 1)开始, 那么第一个for循环的条件应该改为(sum.length - 1)。

那么为什么这么改呢, 因为题目中规定了不能重复利用数组中同样的元素, 也就是说, 如果传入的数组为 {5, 5}, 那么结果如果是 {0, 0}就是错的, {0, 1} 才是正确答案。

其次, 题目中说可以假设每种输入只会对应一个答案, 那么等到进入if语句中之后就说明已经有正确答案了, 这个时候获取到正确答案之后直接返回就好了, 所以, 正确的写法是:

```java
public int twoSum(int[] sums, ,int target) {
    int[] result = new int[2];
    
    for (int i = 0; i != (sums.length - 1); ++i) {
        for (int j = (i + 1); j != sums.length; ++j) {
            if (sums[i] + sums[j] == target) {
                result[0] = i;
                result[1] = j;
                return result;
            }
        }
    }
    return null;
}
```


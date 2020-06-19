---
title: MySql8.0以上only_full_group_by的问题
date: 2019-12-01 09:51:45
categories:
- 数据库
- mysql
- 踩坑
tags:
- mysql
- 踩坑
---

# 问题

当在使用mysql8.0以上的版本时, 在使用`group by`时, 会出现类似下面的报错:

```
ERROR 1055(42000): Expression #7 of SELECT list is not in GROUP BY clause and contains nonaggregated column ....
this is incompatible with sql_mode=only_full_group_by
```

在 mysql 8.0 以上的版本中, 对于 group by 这种聚合操作, 如果在 select 中的列, 没有在 group by 中出现, 那么这个 sql 是不合法的。因为列不在 group by 的从句中, 所以对于设置了这个 mode 的数据库, 在使用 group by 的时候, 就要用 MAX(), SUM() 的这种聚合函数, 才能完成 group by 的聚合操作。

# 解决方案

可以通过以下方式关闭:

在 my.cnf 添加如下配置:
```
[mysqld]

sql_mode="NO_AUTO_VALUE_ON_ZERO,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVSION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,PIPES_AS_CONCAT,ANSI_QUOTES"
```

注意, 这里NO_AUTO_CREATOR_USER选项在 mysql8 中已经取消, 不能加入这个。

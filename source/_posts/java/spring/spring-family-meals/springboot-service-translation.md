---
title: springboot事务介绍
date: 2019-05-20 22:13:25
categories:
- 后端
- java
- spring
tags:
- java
- spring
---

# 前言

这一篇博客主要介绍了spring的事务。

<!--more-->

# 事务抽象的核心接口

不同的数据源事务都实现了PlatformTransactionManager, 比如:

| 数据库类型 | 数据库事务接口 |
| :--------: | :------------: |
| jdbc | DataSourceTransactionManager |
| hibernate | HibernateTransactionManager |
| jta | JtaTransactionManager |

# 事务的相关设置

通过TransactionDefinition接口来设置:

* Propagation 传播性
* Isolation 隔离性
* Timeout 超时
* Read-only status 只读状态

# 事物的传播特性

| 传播性 | 值 | 描述 |
| :----: | :-:| :--: |
| PROPAGATION_REQUIRED | 0 | 当前有事务就用当前的, 没有就用新的 |
| PROPAGATION_SUPOORTS | 1 | 事务可有可无, 不是必须的 |
| PROPAGATION_MANATORY | 2 | 当前一定要有事务, 不然就抛异常 |
| PROPAGATION_REQUIRES_NEW | 3 | 无论是否有事务, 都起个新的事务 |
| PROPAGATION_NOT_SUPPORTED | 4 | 不支持事务, 按非事务方式运行 |
| PROPAGATION_NEVER | 5 | 不支持事务, 如果有事务则抛异常 |
| PROPAGATION_NESTED | 6 | 当前有事务就在当前事务里再起一个新的事务 |

# 事务类型

* 编程式事务
* 声明式事务

## 编程式事务

通过代码的方式执行事务:

```java
@Autowird
private TransactionTemplate mTransactionTemplate;
private void executeTransaction() {
    mTransactionTemplate.execute(new TransactionCallbackWithoutResult() {
        @Override
        protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
            mJdbcTemplate.execute("insert into Foo(bar) values('bbb')");
            transactionStatus.setRollbackOnly();
        }
    });
}
```

> 这里使用了TransactionTemplate的execute()方法, 接着我们在这个方法中执行了对数据库操作的代码, 并将事务的状态设置为只能回滚, 那么这个事务在执行之后依然不会对数据库进行操作。

## 声明式事务

通过注解或者xml的方式声明事务:

```java
@Autowired
private JdbcTemplate mJdbcTemplate;

@Transactional
public void insertData() {
    mJdbcTemplate.execute("insert into Foo(bar) values('AAA')");
}

@Transactional(rollbackFor = Exception.class)
public void insertThenRollBack() throws Exception {
    insertData();
    throw new Exception();
}

@Transactional
public void invokeInsertThenRollBack() throws Exception {
    insertThenRollBack();
}
```

> 这里有三个方法都启动了事务, 其中第二个方法指定了如果抛出指定异常则回滚, 第三个方法虽然调用了第二方法, 但是并没有指定抛出异常后回滚, 所以还是会对数据库进行操作。

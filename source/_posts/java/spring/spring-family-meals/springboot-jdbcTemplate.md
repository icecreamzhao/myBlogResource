---
title: springboot jdbcTemplate介绍
date: 2019-05-20 17:48:06
categories:
- Java
- spring
- 学习
tags:
- Java
- spring
---

# 前言

本片博客主要介绍了JdbcTemplate的一些常用的方法。

<!--more-->

# 增加, 修改和删除

对数据库中的数据进行修改的操作统一使用一个update()方法, 下面我们来看一个增加数据的例子:

```java
@Autowired
private JdbcTemplate mJdbcTemplate;

public void insertData() {
    Arrays.asList("a", "b").forEach(bar -> {
        mJdbcTemplate.update("insert into Foo(bar) values(?)", bar);
    });
}
```

## SimpleJdbcInsert

还有一个对数据库进行简单插入的辅助类: `SimpleJdbcInsert`, 下面我们来看一个例子:

首先声明一个SimpleJdbcInsert类的bean:

```java
// configuration类

@Bean
public SimpleJdbcInsert mSimpleJdbcInsert(JdbcTemplate jdbcTemplate) {
    return new SimpleJdbcInsert(jdbcTemplate)
            .withTableName("Foo").usingGeneratedKeyColumns("id");
}
```

这里直接定义了表名和主键的名字, 接下来执行数据库的操作:

```java
@Autowired
private SimpleJdbcInsert mSimpleJdbcInsert;

public void insertData() {
    HashMap<String, String> row = new HashMap<>();
    row.put("bar", "b");
    Number id = mSimpleJdbcInsert.executeAndReturnKey(row);
    log.info("ID of d: {}", id.intValue());
}
```

这里直接使用`executeAndReturnKey()`方法, 将刚刚插入的数据的主键返回。

# 查询

查询有三个方法:`queryForObject()`, `queryForList()`, `query()`

## queryForObject

```java
public void listData() {
    // queryForObject
    log.info("Count: {}", mJdbcTemplate.queryForObject("select count(*) from Foo", Long.class));
}
```
> 这里由于查询的结果是数字, 所以可以直接传入Long.class, 下面的也是一样的道理。

## queryForList

```java
public void listData() {
    // queryForList
    List<String> list = mJdbcTemplate.queryForList("select bar from Foo", String.class);
}
```

## query

```java
public void listData() {
    // query
    List<Foo> fooList = mJdbcTemplate.query("select * from Foo", new RowMapper<Foo>() {
        @Override
        public Foo mapRow(ResultSet resultSet, int i) throws SQLException {
            Foo foo = new Foo();
            foo.setId(resultSet.getInt(1));
            foo.setBar(resultSet.getString(2));
            return foo;
        }
    });

    fooList.forEach(f -> log.info("Foo: {}", f));
}
```

> 这里由于查出的是一个对象, 则可以使用RowMapper来对这个对象的属性进行对应。

# 批量操作

可以使用jdbcTemplate的batchUpdate()方法。

```java
public void batchInsertData() {
    mJdbcTemplate.batchUpdate("insert into Foo(bar) values (?)", new BatchPreparedStatementSetter() {
        // 这里用来设置sql中的?对应的值
        @Override
        public void setValues(PreparedStatement preparedStatement, int i) throws SQLException {
            preparedStatement.setString(1, "b-" + i);
        }

        // 这里设置批量操作的次数
        @Override
        public int getBatchSize() {
            return 2;
        }
    });
}
```

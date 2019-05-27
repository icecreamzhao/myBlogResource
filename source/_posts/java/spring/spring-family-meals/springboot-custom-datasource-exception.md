---
title: springboot自定义数据库异常
date: 2019-05-21 11:33:40
categories:
- Java
- spring
- 学习
tags:
- Java
- spring
---

# 前言

有的时候可能会需要自定义数据库的异常并且在某种希望的情况抛出, 比如如果在程序中加入了数据层的代理, 这个代理有可能会抛出自己的的一些错误码, 那么就需要自己定义异常然后根据错误码抛出。

<!--more-->

# 数据库异常

所有的异常都继承自`DataAccessException`, 如果我们要定义自己的异常可以直接继承自这个类。

如果我们需要根据特定的错误码来抛出自定义的异常, 可以将错误码定义到`resources/sql-error-codes.xml`这个文件中, 这样就会覆盖掉官方的默认的错误码, 这有个例子:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN 2.0//EN" "https://www.springframework.org/dtd/spring-beans-2.0.dtd">
<beans>
    <bean id="MySQL" class="org.springframework.jdbc.support.SQLErrorCodes">
        <property name="databaseProductNames">
            <list>
                <value>MySQL</value>
                <value>MariaDB</value>
            </list>
        </property>
        <property name="badSqlGrammarCodes">
            <value>1054,1064,1146</value>
        </property>
        <property name="duplicateKeyCodes">
            <value>1062</value>
        </property>
        <property name="dataIntegrityViolationCodes">
            <value>630,839,840,893,1169,1215,1216,1217,1364,1451,1452,1557</value>
        </property>
        <property name="dataAccessResourceFailureCodes">
            <value>1</value>
        </property>
        <property name="cannotAcquireLockCodes">
            <value>1205</value>
        </property>
        <property name="deadlockLoserCodes">
            <value>1213</value>
        </property>
        <property name="customTranslations">
            <bean class="org.springframework.jdbc.support.CustomSQLErrorCodesTranslation">
                <property name="errorCodes" value="1062" />
                <property name="exceptionClass"
                          value="com.littleboy.exception.CustomDuplicateException" />
            </bean>
        </property>
    </bean>
</beans>
```

这里我将`1062`这个错误码(也就是mysql的重复主键)定义为当出现这个错误的时候抛出我自己定义的异常`CustomDuplicateException`。

CustomDuplicateException:

```java
public class CustomDuplicateException extends DuplicateKeyException {
    public CustomDuplicateException(String msg) {
        super(msg);
    }

    public CustomDuplicateException(String msg, Throwable cause) {
        super(msg, cause);
    }
}
```

下面我们来测试一下:

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class Chapter12ApplicationTests {
    @Autowired
    private JdbcTemplate mJdbcTemplate;

    @Test(expected = CustomDuplicateException.class)
    public void contextLoads() {
        mJdbcTemplate.execute("insert into Foo(id, bar) values(1, 'a')");
    }

}
```

这里我们指定如果这个单元测试抛出了`CustDuplicateException`则通过。

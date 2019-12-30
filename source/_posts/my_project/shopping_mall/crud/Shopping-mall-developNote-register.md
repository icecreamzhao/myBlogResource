---
title: 商城开发笔记-注册
date: 2019-10-29 13:39:32
categories:
- 开发笔记
- 商城
- 功能篇
tags:
- 商城开发
---

# 目标

* 创建用户表
* 编写添加用户功能

# 创建用户表

由于我们已经使用了actable框架, 可以实现通过实体类自动创建表, 所以我们只需要设计好实体类就可以了。

我们在 pojo 模块中新建 `BasePojo.java` 用来充当我们的实体类基类。

<!--more-->

BasePojo.java:

```java
package com.littleboy.pojo;

import com.gitee.sunchenbin.mybatis.actable.annotation.Column;
import com.gitee.sunchenbin.mybatis.actable.constants.MySqlTypeConstant;
import com.littleboy.common.annotation.CreateTime;
import com.littleboy.common.annotation.UpdateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
class BasePojo implements Serializable {
	@Column(name = "id", type = MySqlTypeConstant.VARCHAR, length = 32, isKey = true, comment = "主键")
	private String id;

	@CreateTime
	@Column(name = "create_time", type = MySqlTypeConstant.TIMESTAMP, isNull = false, comment = "创建时间")
	private Timestamp createTime;

	@UpdateTime
	@Column(name = "update_time", type = MySqlTypeConstant.TIMESTAMP, isNull = false, comment = "更新时间")
	private Timestamp updateTime;
}
```

OK, 这样只要继承了这个类的实体类都会拥有 createTime 和 updateTime 字段了, 这里 `@CreateTime` 和 `@UpdateTime` 可能会报错, 别急, 我们马上来实现他们。

接下来我们要写两个注解, 用来在插入或者更新表时自动添加或者更新时间戳。在 common 模块中新建 `annotation` 和 `interceptor` 包, 在 `annotation` 中新建两个注解:
CreateTime.java:

```java
package com.littleboy.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD})
public @interface CreateTime {
}
```

UpdateTime.java:

```java
package com.littleboy.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD})
public @interface UpdateTime {
}
```

mybatis 有一个拦截器, 可以在执行 sql 之前做自己想做的事, 那么思路就比较清晰了, 在插入或者更新的时候, 检测每一个实体类的字段有没有加入 `@CreateTime` 和 `@UpdateTime`, 如果有, 则将该字段设置好当前时间就可以了。那么具体的实现步骤如下:

```java
package com.littleboy.common.interceptor;

import com.littleboy.common.annotation.CreateTime;
import com.littleboy.common.annotation.UpdateTime;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.ibatis.binding.MapperMethod;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.*;

import java.lang.reflect.Field;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;

@Intercepts({@Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})})
public class DateTimeInterceptor implements Interceptor {
	@Override
	public Object intercept(Invocation invocation) throws Throwable {
		MappedStatement mappedStatement = (MappedStatement)invocation.getArgs()[0];

		// 获取 SQL
		SqlCommandType sqlCommandType = mappedStatement.getSqlCommandType();

		// 获取参数
		Object parameter = invocation.getArgs()[1];
		Object param = null;

		// 获取私有成员变量
		if (((MapperMethod.ParamMap)parameter).size() > 1) {
			Iterator iterator = ((MapperMethod.ParamMap)parameter).keySet().iterator();
			while (iterator.hasNext()) {
				param = ((MapperMethod.ParamMap)parameter).get(iterator.next());
			}
		}
		Field[] declaredFields = getAllFields(param);

		for (Field field : declaredFields) {
			field.setAccessible(true);
			if (field.getAnnotation(CreateTime.class) != null) {
				if (SqlCommandType.INSERT.equals(sqlCommandType)) {
					// insert语句插入createTime
					// 这里设置时间，当然时间格式可以自定。比如转成String类型
					field.set(param, Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
				}
			}
			else if (field.getAnnotation(UpdateTime.class) != null) {

				if (SqlCommandType.INSERT.equals(sqlCommandType)
						|| SqlCommandType.UPDATE.equals(sqlCommandType)) {
					// insert 或update语句插入updateTime
					field.set(param, Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
				}
			}
		}

		return invocation.proceed();
	}

	/**
	 * 递归获取该类以及该类的父类所有的注解
	 * @param obj 需要获取的类的实例
	 * @param <T> 类型
	 * @return 全部的注解
	 */
	private <T> Field[] getAllFields(T obj) {
		Field[] declaredFields = obj.getClass().getDeclaredFields();
		declaredFields = recursionParents(obj.getClass(), declaredFields);

		return declaredFields;
	}

	/**
	 * 递归获取父类的注解
	 * @param clas   反射的class
	 * @param fields 全部注解
	 * @return 全部的注解
	 */
	private Field[] recursionParents(Class<?> clas, Field[] fields) {
		if (clas.getSuperclass() != null) {
			Class clasSup = clas.getSuperclass();
			fields = ArrayUtils.addAll(fields, clasSup.getDeclaredFields());
			fields = recursionParents(clasSup, fields);
		}
		return fields;
	}

	@Override
	public Object plugin(Object o) {
		return Plugin.wrap(o, this);
	}

	@Override
	public void setProperties(Properties properties) {}
}
```

ok, 基类实现好了, 接下来开始设计用户实体类:

SXUser.java:

```java
package com.littleboy.pojo;

import com.gitee.sunchenbin.mybatis.actable.annotation.Column;
import com.gitee.sunchenbin.mybatis.actable.annotation.Table;
import com.gitee.sunchenbin.mybatis.actable.constants.MySqlTypeConstant;

import java.sql.Timestamp;

import com.littleboy.common.annotation.CreateTime;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
@Table(name = "sx_user", comment = "用户表")
public class SXUser extends BasePojo {

	@Column(name = "account", type = MySqlTypeConstant.VARCHAR, length = 20, isNull = false, comment = "账号(手机号)")
	private String account;

	@Column(name = "passwd", type = MySqlTypeConstant.VARCHAR, length = 60, isNull = false, comment = "密码")
	private String passwd;

	@Column(name = "name", type = MySqlTypeConstant.VARCHAR, length = 10, isNull = false, comment = "真实姓名")
	private String name;

	@Column(name = "status", type = MySqlTypeConstant.SMALLINT, defaultValue = "0", isNull = false, comment = "-1 不可用 0 刚注册,未完善资料 1 完善了资料,未审核 2 审核过")
	private int status;

	@Column(name = "type", type = MySqlTypeConstant.TINYINT, defaultValue = "1", isNull = false, comment = "1买家 2卖家")
	private int type;

	@CreateTime
	@Column(name = "last_login_time", type = MySqlTypeConstant.TIMESTAMP,isNull = false, comment = "最后一次登录时间")
	private Timestamp lastLoginTime;
}
```

ok, 用户表设计好了, 接下来就是编写添加用户的功能了。

# 添加用户

首先编写 dao 层:

dao.SXUserMapper.java:

```java
package com.littleboy.dao;

import com.littleboy.pojo.SXUser;
import org.apache.ibatis.annotations.Param;

public interface SXUserMapper {
    /**
     * 通过id获取用户
     * @param id 用户id
     * @return 获取到的用户
     */
    SXUser getUserById(@Param("id") String id);

    /**
     * 通过手机号获取用户
     * @param account 手机号
     * @return 获取到的用户
     */
    SXUser getUserByAccount(@Param("account") String account);

    /**
     * 插入一条用户记录
     * @param user 用户记录
     */
    void insertUser(@Param("user") SXUser user);
}
```

接下来是对应的 xml:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.littleboy.dao.SXUserMapper">
    <select id="getUserById" resultType="SXUser" parameterType="String">
        select * from sx_user where sx_user.id = #{id}
    </select>

    <select id="getUserByAccount" resultType="SXUser" parameterType="String">
        select * from sx_user where sx_user.account = #{name}
    </select>

    <insert id="insertUser" parameterType="com.littleboy.pojo.SXUser">
        insert sx_user(id, account, passwd, name, create_time, update_time, last_login_time)
        values (#{user.id}, #{user.account}, #{user.passwd}, #{user.name}, #{user.createTime}, #{user.updateTime}, #{user.lastLoginTime})
    </insert>
</mapper>
```

服务层省略, 代码可以查看 [码云-商城源码](https://gitee.com/littleboydk/shopping_mall)。

controller层:

```java
package com.littleboy.controller;

import com.littleboy.dto.ReturnInfo;
import com.littleboy.dto.UserDto;
import com.littleboy.pojo.SXUser;
import com.littleboy.service.SXUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/user")
public class UserController {
    @Autowired
    private SXUserService mSXUserService;

    /**
     * 用户注册
     * @param userDto 用户注册信息
     * @return 用户注册成功的信息
     */
    @PostMapping(value = "/register")
    public ReturnInfo register(@RequestBody UserDto userDto) {
        System.out.println(userDto);
        ReturnInfo<UserDto> returnInfo = new ReturnInfo<>();
        if (!StringUtils.isAllEmpty(userDto.getAccount()) &&
                !StringUtils.isAllEmpty(userDto.getPasswd()) &&
                !StringUtils.isAllEmpty(userDto.getName())) {

            mSXUserService.insertUser(
                    SXUser.builder()
                            .account(userDto.getAccount())
                            .passwd(new BCryptPasswordEncoder().encode(userDto.getPasswd()))
                            .name(userDto.getName()).build());

            returnInfo.setObject(userDto);
            returnInfo.setReturnInfo("恭喜你, 注册成功! ");
            returnInfo.setStatus(1);
        } else {
            returnInfo.setStatus(-1);
            returnInfo.setReturnInfo("很抱歉, 注册失败, 请检查您填写的信息是否正确");
        }
        return returnInfo;
    }
}

```

这里使用了 SpringSecurity 的密码加密方式, 嗯, 接口搞定, 写个测试用例测试一下:


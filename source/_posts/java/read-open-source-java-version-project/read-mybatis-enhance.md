---
title: 读mybatis-enhance开源项目
date: 2019-01-12 14:12:43
categories:
- Java
- 读开源项目
tags:
- mybatis
- 开源项目
---

# 前言

mybatis 和 hibernate 是最受欢迎的orm框架之二, 但是我一直觉得hibernate这个框架对于我来说还是太重了, 而且稍有不注意性能上就会损失巨大, 所以mybatis成为了我的首选。
但是hibernate有一个功能我非常喜欢, 就是可以根据实体类自动建表, 那我就想mybatis可不可以也做到这一点呢? 那么就让我来介绍一下[ACTable](http://git.oschina.net/sunchenbin/mybatis-enhance)这个开源工具, 他可以让mybatis实现自动建表的功能, 具体的使用方法大家可以通过上面的链接查看, 这篇博客主要是来记录一下这个工具的实现思路。

<!--more-->

# 实现思路
<br>
## 注解层

这个工具有三个注解, 分别是 `Column`, `LengthCount` 和 `Table`

* Column 是注解到字段上的, 用来指定字段的名字, 类型, 长度等
* LengthCount 是用来标记数据库类型的长度
* Table 用来指定表名

<br>

## 入口

在`manager.handler.StartUpHandler` 中定义了入口方法 `startHandler()`, 该方法使用了`@PostConstruct`注解, 该注解是Spring的注解, 使用了该注解的方法会在依赖注入(`@Autowired`)之后自动执行。
```java
public void startHandler() {

	// 执行mysql的处理方法
	if (MYSQL.equals(databaseType)) {
		
		log.info("databaseType=mysql，开始执行mysql的处理方法");
		
		sysMysqlCreateTableManager.createMysqlTable();
	}else{
		
		log.info("没有找到符合条件的处理方法！");
	}
}
```

<br>

可以看到该方法调用了`SysMysqlCreateTableManager`这个类的`createMysqlTable()`方法:

<br>

```java
public void createMysqlTable() {

	// 不做任何事情
	if ("none".equals(tableAuto)) {
		log.info("配置mybatis.table.auto=none，不需要做任何事情");
		return;
	}

	// 获取Mysql的类型，以及类型需要设置几个长度
	Map<String, Object> mySqlTypeAndLengthMap = mySqlTypeAndLengthMap();

	// 从包package中获取所有的Class
	Set<Class<?>> classes = ClassTools.getClasses(pack);

	// 用于存需要创建的表名+结构
	Map<String, List<Object>> newTableMap = new HashMap<String, List<Object>>();

	// 用于存需要更新字段类型等的表名+结构
	Map<String, List<Object>> modifyTableMap = new HashMap<String, List<Object>>();

	// 用于存需要增加字段的表名+结构
	Map<String, List<Object>> addTableMap = new HashMap<String, List<Object>>();

	// 用于存需要删除字段的表名+结构
	Map<String, List<Object>> removeTableMap = new HashMap<String, List<Object>>();

	// 用于存需要删除主键的表名+结构
	Map<String, List<Object>> dropKeyTableMap = new HashMap<String, List<Object>>();

	// 用于存需要删除唯一约束的表名+结构
	Map<String, List<Object>> dropUniqueTableMap = new HashMap<String, List<Object>>();

	// 构建出全部表的增删改的map
	allTableMapConstruct(mySqlTypeAndLengthMap, classes, newTableMap, modifyTableMap, addTableMap, removeTableMap,
			dropKeyTableMap, dropUniqueTableMap);

		// 根据传入的map，分别去创建或修改表结构
		createOrModifyTableConstruct(newTableMap, modifyTableMap, addTableMap, removeTableMap, dropKeyTableMap,
				dropUniqueTableMap);
	}
	```
嗯, 注释写的已经非常清楚了, 首先检测用户配置的状态是什么, 然后构建操作表的sql, 最后进行实际操作。
值得注意的是, 这里有一个操作可以根据用户配置的包名来获取到所有实体类的Class, [这篇博文](/java/read-open-source-java-version-project/read-mybatis-enhance-ClassTools.html)对这里进行了分析。

<br>

## 构建出全部表的增删改的map

看完了大体的思路, 接下来就来看看是怎么具体实现的。
首先来看看他是怎么构建出全部表的增删改的map的。
```java
/**
* 构建出全部表的增删改的map
* 
* @param mySqlTypeAndLengthMap
*            获取Mysql的类型，以及类型需要设置几个长度
* @param classes
*            从包package中获取所有的Class
* @param newTableMap
*            用于存需要创建的表名+结构
* @param modifyTableMap
*            用于存需要更新字段类型等的表名+结构
* @param addTableMap
*            用于存需要增加字段的表名+结构
* @param removeTableMap
*            用于存需要删除字段的表名+结构
* @param dropKeyTableMap
*            用于存需要删除主键的表名+结构
* @param dropUniqueTableMap
*            用于存需要删除唯一约束的表名+结构
*/
private void allTableMapConstruct(Map<String, Object> mySqlTypeAndLengthMap, Set<Class<?>> classes,
		Map<String, List<Object>> newTableMap, Map<String, List<Object>> modifyTableMap,
		Map<String, List<Object>> addTableMap, Map<String, List<Object>> removeTableMap,
		Map<String, List<Object>> dropKeyTableMap, Map<String, List<Object>> dropUniqueTableMap) {
	for (Class<?> clas : classes) {

		Table table = clas.getAnnotation(Table.class);
		// 没有打注解不需要创建变量
		if (null == table) {
			continue;
		}

		// 用于存新增表的字段
		List<Object> newFieldList = new ArrayList<Object>();
		// 用于存删除的字段
		List<Object> removeFieldList = new ArrayList<Object>();
		// 用于存新增的字段
		List<Object> addFieldList = new ArrayList<Object>();
		// 用于存修改的字段
		List<Object> modifyFieldList = new ArrayList<Object>();
		// 用于存删除主键的字段
		List<Object> dropKeyFieldList = new ArrayList<Object>();
		// 用于存删除唯一约束的字段
		List<Object> dropUniqueFieldList = new ArrayList<Object>();

		// 迭代出所有model的所有fields存到newFieldList中
		tableFieldsConstruct(mySqlTypeAndLengthMap, clas, newFieldList);

		// 如果配置文件配置的是create，表示将所有的表删掉重新创建
		if ("create".equals(tableAuto)) {
			createMysqlTablesMapper.dorpTableByName(table.name());
		}

		// 先查该表是否以存在
		int exist = createMysqlTablesMapper.findTableCountByTableName(table.name());

		// 不存在时
		if (exist == 0) {
			newTableMap.put(table.name(), newFieldList);
		} else {
			// 已存在时理论上做修改的操作，这里查出该表的结构
			List<SysMysqlColumns> tableColumnList = createMysqlTablesMapper
					.findTableEnsembleByTableName(table.name());

			// 从sysColumns中取出我们需要比较的列的List
			// 先取出name用来筛选出增加和删除的字段
			List<String> columnNames = ClassTools.getPropertyValueList(tableColumnList,
					SysMysqlColumns.COLUMN_NAME_KEY);

			// 验证对比从model中解析的fieldList与从数据库查出来的columnList
			// 1. 找出增加的字段
			// 2. 找出删除的字段
			// 3. 找出更新的字段
			buildAddAndRemoveAndModifyFields(mySqlTypeAndLengthMap, modifyTableMap, addTableMap, removeTableMap,
					dropKeyTableMap, dropUniqueTableMap, table, newFieldList, removeFieldList, addFieldList,
					modifyFieldList, dropKeyFieldList, dropUniqueFieldList, tableColumnList, columnNames);

		}
	}
}
```
首先遍历实体类class集合, 检测是否声明了`@Table`注解, 这里利用了反射机制, 使用了Class类的`getAnnotation(Class<?>)`方法, 检测该类是否声明了参数中传入的注解。
接着声明了一些集合, 分别用来存储新增表的字段, 删除的字段, 修改的字段, 新增的字段, 删除主键的字段以及删除唯一约束的字段。
然后将所有的实体类的字段获取到, [这篇博文](/)对这里进行了分析。
接着如果用户声明的策略是create, 则删除所有的表重新创建。
接着判断表是否存在, 当表不存在时, 直接创建新表。当表已经存在时, 先查出表的结构, 接着
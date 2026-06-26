# SchoolLibrary 图书管理系统

本项目是“基于 JavaEE 的图书管理系统的设计与实现”的完整 SSM + JSP 示例工程。

## 一、建议本地存放路径

```text
E:\SchoolLibrary
```

## 二、技术栈

- 后端：Spring + SpringMVC + MyBatis
- 前端：JSP + HTML + CSS + JavaScript + JSTL
- 数据库：MySQL
- 运行环境：JDK 1.8+、Tomcat 8.5/9、Maven 3.6+

## 三、运行步骤

1. 在 MySQL 中执行：

```sql
CREATE DATABASE school_library DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

2. 执行 `src/main/resources/sql/schema.sql` 初始化数据表和测试账号。

3. 修改数据库连接配置：

```text
src/main/resources/db.properties
```

4. 在项目根目录执行：

```bash
mvn clean package
```

5. 将生成的 `target/SchoolLibrary.war` 放入 Tomcat 的 `webapps` 目录。

6. 浏览器访问：

```text
http://localhost:8080/SchoolLibrary/login
```

## 四、默认账号

管理员：

```text
账号：admin
密码：123456
```

读者：

```text
账号：R2026001
密码：123456
```

## 五、项目说明

代码中已经加入中文注释，重点说明了 Controller、Service、Mapper、实体类、权限拦截器、JSP 页面的职责。

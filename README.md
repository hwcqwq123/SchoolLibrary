# SchoolLibrary v2 项目说明与当前状态

> 适用分支：`feature-v2-full-library-system`  
> 项目路径建议：`E:\SchoolLibrary`  
> Web 访问根路径：`http://localhost:8080/SchoolLibrary`

---

## 1. 项目简介

`SchoolLibrary` 是一个基于 Spring、SpringMVC、MyBatis、JSP、MySQL、Tomcat 的校园图书馆管理系统。

当前 v2 版本在原有基础图书管理系统上扩展了管理员端和读者端功能，重点包括：

- 管理员首页看板
- 图书管理
- 分类管理
- 读者管理
- 借阅管理
- 续借审核
- 逾期罚款
- 座位预约管理
- 公告管理
- 数据维护
- 系统管理
- 读者首页
- 读者图书查询
- 我的借阅
- 座位预约
- 个人中心

---

## 2. 技术栈

| 类型 | 技术 |
|---|---|
| 后端框架 | Spring + SpringMVC |
| ORM | MyBatis |
| 前端 | JSP + JSTL + CSS |
| 数据库 | MySQL |
| Web 容器 | Tomcat 8.5 |
| 构建工具 | Maven |
| 版本管理 | Git / GitHub |

---

## 3. 目录说明

核心目录如下：

```text
SchoolLibrary
├── src
│   ├── main
│   │   ├── java
│   │   │   └── cn/edu/library
│   │   │       ├── controller
│   │   │       ├── mapper
│   │   │       ├── entity
│   │   │       ├── service
│   │   │       ├── interceptor
│   │   │       ├── filter
│   │   │       └── util
│   │   ├── resources
│   │   │   ├── mapper
│   │   │   ├── spring
│   │   │   └── sql
│   │   └── webapp
│   │       ├── assets
│   │       └── WEB-INF/views
├── pom.xml
└── deploy.ps1
```

---

## 4. 默认访问地址

### 登录页

```text
http://localhost:8080/SchoolLibrary/login
```

### 管理员端

```text
http://localhost:8080/SchoolLibrary/admin/v2/dashboard
```

### 读者端

```text
http://localhost:8080/SchoolLibrary/reader/v2/home
```

### Debug 地址

```text
http://localhost:8080/SchoolLibrary/debug/ping
http://localhost:8080/SchoolLibrary/debug/session
http://localhost:8080/SchoolLibrary/debug/paths
```

---

## 5. 默认账号

### 管理员账号

```text
账号：admin
密码：123456
身份：管理员
```

### 读者账号

```text
账号：R2026001
密码：123456
身份：读者
```

---

## 6. 数据库初始化

当前项目建议统一只维护一个 SQL 初始化文件：

```text
src/main/resources/sql/schema.sql
```

执行方式：

```sql
source E:/SchoolLibrary/src/main/resources/sql/schema.sql;
```

注意：当前 `schema.sql` 是完整初始化脚本，会重建数据库和基础数据。开发调试阶段可以直接执行；如果以后进入正式数据阶段，需要改成增量迁移脚本，避免清空业务数据。

---

## 7. 编译与部署

必须在项目根目录执行 Maven：

```powershell
cd E:\SchoolLibrary
mvn clean package -DskipTests
```

看到下面结果说明编译成功：

```text
BUILD SUCCESS
```

然后部署：

```powershell
.\deploy.ps1
```

如果 Tomcat 中存在旧缓存，建议先清理：

```powershell
$TOMCAT_HOME="C:\apache-tomcat-8.5.58"

Remove-Item "$TOMCAT_HOME\webapps\SchoolLibrary" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$TOMCAT_HOME\webapps\SchoolLibrary.war" -Force -ErrorAction SilentlyContinue
Remove-Item "$TOMCAT_HOME\work\Catalina\localhost\SchoolLibrary" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$TOMCAT_HOME\temp\*" -Recurse -Force -ErrorAction SilentlyContinue
```

---

## 8. 当前 v2 已修复的问题

### 8.1 登录成功后又跳回登录页

原因：

- 登录成功后 `LoginController` 写入的是 `userType`
- 旧拦截器判断的是 `loginRole`
- 两边 Session 字段不统一，导致登录成功后被拦截器踢回 `/login`

当前修复：

- `LoginController` 同时写入 `userType` 和 `loginRole`
- `LoginInterceptor` 同时兼容 `userType` 和 `loginRole`

---

### 8.2 `/admin/v2/dashboard` 加载 500

曾出现的问题：

```text
Unknown column 'due_date' in 'where clause'
```

原因：

- `V2Mapper.xml` 使用 `due_date`
- 原始数据库字段是 `due_time`

当前修复：

- 整合后的 `schema.sql` 已兼容 `borrow_time / due_time / return_time`
- 同时新增 `borrow_date / due_date / return_date`

---

### 8.3 分类管理 500

曾出现的问题：

```text
Unknown column 'c.description' in 'field list'
```

原因：

- `V2Mapper.xml` 查询 `book_category.description`
- 原始 `book_category` 表缺少 `description`

当前修复：

- `schema.sql` 已为 `book_category` 增加 `description`

---

### 8.4 JSP 日期格式化 500

曾出现的问题：

```text
Cannot convert LocalDateTime to java.util.Date
```

原因：

- JSP 中使用 `<fmt:formatDate>`
- 后端返回的是 `java.time.LocalDateTime`
- JSTL 无法直接格式化 `LocalDateTime`

当前修复：

- v2 页面中尽量不再使用 `<fmt:formatDate>`
- 改为使用字符串展示，例如：

```jsp
${fn:replace(item.createTime, 'T', ' ')}
```

---

### 8.5 点击图书管理跳回旧页面

原因：

- 旧路径 `/admin/books` 仍然由旧 Controller 返回旧 JSP 页面
- v2 页面和旧页面布局不统一

当前修复：

- v2 菜单统一使用 `/admin/v2/**`
- 部分旧入口通过 Controller redirect 到 v2 页面
- 管理员端和读者端统一侧边栏布局

---

### 8.6 座位预约重复预约问题

当前规则：

- 同一读者在同一日期、同一时段只能预约一个座位
- 不能预约过去日期
- 不能预约今天已经结束的时段

该规则需要前端提示和后端校验同时存在。前端只负责用户体验，最终约束以后端校验为准。

---

## 9. UI 设计约定

当前 v2 前端统一采用蓝色系 UI。

### 侧边栏

- 管理员端和读者端统一使用左侧侧边栏
- 当前选中的菜单按钮颜色变浅
- 选中态用于表示当前页面位置
- 不再使用多个页面各自独立的顶部导航

### 首页看板

管理员首页看板应包含：

- 蓝色渐变欢迎区
- 统计卡片
- 分类馆藏统计
- 最新公告
- 最近借阅
- 逾期提醒
- 简单进度条或可视化模块

---

## 10. 推荐测试清单

### 管理员端

```text
/admin/v2/dashboard
/admin/v2/books
/admin/v2/readers
/admin/v2/borrows
/admin/v2/categories
/admin/v2/renews
/admin/v2/fines
/admin/v2/seats
/admin/v2/notices
/admin/v2/data
/admin/v2/system
```

### 读者端

```text
/reader/v2/home
/reader/v2/books
/reader/v2/borrows
/reader/v2/seats
/reader/v2/profile
```

### 旧路径兼容测试

```text
/admin/books
/admin/readers
/admin/borrow/list
/admin/dashboard
```

这些旧入口不应该再跳回旧布局页面，应该进入对应 v2 页面或兼容页面。

---

## 11. Git 提交流程

```powershell
cd E:\SchoolLibrary

git status
git add .
git commit -m "Your commit message"
git push -u origin feature-v2-full-library-system
```

如果 HTTPS 推送失败，可以尝试：

```powershell
git config --global http.sslBackend schannel
git config --global http.version HTTP/1.1
git config --global http.postBuffer 524288000
git config --global core.compression 0
```

如果仍然失败，建议改用 SSH：

```powershell
git remote set-url origin git@github.com:hwcqwq123/SchoolLibrary.git
git push -u origin feature-v2-full-library-system
```

---

## 12. 后续建议

后续开发建议优先处理以下事项：

1. 彻底统一旧 Controller 和 v2 Controller 的跳转逻辑。
2. 删除或封存不再使用的旧 JSP 页面，避免误跳回旧布局。
3. 把所有数据库修改从完整初始化脚本逐步拆分为增量迁移脚本。
4. 为座位预约、续借、罚款生成增加事务控制。
5. 为关键业务接口增加后端参数校验。
6. 为登录、借阅、座位预约、罚款生成增加操作日志。
7. 在页面中增加更明确的成功、失败、错误提示。
8. 在正式提交前执行完整页面测试清单。

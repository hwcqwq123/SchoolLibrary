<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="topbar">
    <div class="brand">图书管理系统 · 读者端</div>
    <div class="user">当前读者：${sessionScope.loginName} ｜ <a href="${ctx}/logout">退出</a></div>
</div>
<div class="layout">
    <aside class="sidebar">
        <a href="${ctx}/reader/home">个人首页</a>
        <a href="${ctx}/reader/books">图书查询</a>
        <a href="${ctx}/reader/borrows">我的借阅</a>
        <a href="${ctx}/reader/password">修改密码</a>
    </aside>
    <main class="content">



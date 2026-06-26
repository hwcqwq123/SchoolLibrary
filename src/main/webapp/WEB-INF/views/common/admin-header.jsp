<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="topbar">
    <div class="brand">图书管理系统 · 管理员端</div>
    <div class="user">当前用户：${sessionScope.loginName} ｜ <a href="${ctx}/logout">退出</a></div>
</div>
<div class="layout">
    <aside class="sidebar">
        <a href="${ctx}/admin/dashboard">首页统计</a>
        <a href="${ctx}/admin/books">图书管理</a>
        <a href="${ctx}/admin/readers">读者管理</a>
        <a href="${ctx}/admin/borrow/list">借阅记录</a>
        <a href="${ctx}/admin/borrow/add">借书登记</a>
    </aside>
    <main class="content">



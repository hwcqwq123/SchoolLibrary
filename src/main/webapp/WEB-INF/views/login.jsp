<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>图书管理系统登录</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body class="login-body">
<div class="login-card">
    <h1>图书管理系统</h1>
    <p class="subtitle">基于 JavaEE/SSM 的图书管理系统</p>
    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>
    <form action="${ctx}/login" method="post">
        <label>账号</label>
        <input type="text" name="username" placeholder="管理员：admin / 读者：R2026001" required>
        <label>密码</label>
        <input type="password" name="password" placeholder="默认：123456" required>
        <label>身份</label>
        <select name="role">
            <option value="ADMIN">管理员</option>
            <option value="READER">读者</option>
        </select>
        <button type="submit">登录系统</button>
    </form>
</div>
</body>
</html>



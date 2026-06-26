<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/reader-header.jsp" %>
<h2>修改密码</h2>
<c:if test="${not empty message}"><div class="alert success">${message}</div></c:if>
<c:if test="${not empty error}"><div class="alert error">${error}</div></c:if>
<form class="form" method="post" action="${ctx}/reader/password">
    <label>旧密码</label>
    <input type="password" name="oldPassword" required>
    <label>新密码</label>
    <input type="password" name="newPassword" required>
    <button class="btn primary" type="submit">确认修改</button>
</form>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



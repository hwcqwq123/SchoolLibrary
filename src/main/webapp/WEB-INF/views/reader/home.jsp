<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    /*
     * 【本次修改】旧 JSP 页面封存。
     * 防止用户从历史链接进入旧布局页面。
     */
    String target = request.getContextPath() + "/reader/v2/home";
    response.sendRedirect(target);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>页面已迁移</title>
    <meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/reader/v2/home">
</head>
<body>
<p>旧版读者首页已封存，正在进入新版读者首页。</p>
<p><a href="${pageContext.request.contextPath}/reader/v2/home">点击进入新版页面</a></p>
</body>
</html>

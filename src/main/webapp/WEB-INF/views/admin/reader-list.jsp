<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>读者管理</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<div class="page-title">
    <h2>读者管理</h2>
    <a class="btn primary" href="${ctx}/admin/reader/add">新增读者</a>
</div>
<form class="search-form" method="get" action="${ctx}/admin/readers">
    <input type="text" name="keyword" value="${keyword}" placeholder="读者编号/姓名/电话/院系">
    <button class="btn" type="submit">查询</button>
</form>
<table class="table">
    <thead><tr><th>读者编号</th><th>姓名</th><th>性别</th><th>电话</th><th>邮箱</th><th>院系</th><th>操作</th></tr></thead>
    <tbody>
    <c:forEach items="${readers}" var="reader">
        <tr>
            <td>${reader.readerNo}</td>
            <td>${reader.name}</td>
            <td>${reader.gender}</td>
            <td>${reader.phone}</td>
            <td>${reader.email}</td>
            <td>${reader.department}</td>
            <td>
                <a class="btn small" href="${ctx}/admin/reader/edit?id=${reader.id}">修改</a>
                <a class="btn small danger" href="${ctx}/admin/reader/delete?id=${reader.id}" onclick="return confirmDelete('确定禁用该读者吗？')">禁用</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



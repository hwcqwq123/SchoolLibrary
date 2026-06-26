<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的借阅</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/reader-header.jsp" %>
<h2>我的借阅记录</h2>
<table class="table">
    <thead><tr><th>图书编号</th><th>书名</th><th>分类</th><th>借阅时间</th><th>应还时间</th><th>归还时间</th><th>状态</th><th>罚款</th></tr></thead>
    <tbody>
    <c:forEach items="${records}" var="r">
        <tr>
            <td>${r.bookNo}</td>
            <td>${r.bookName}</td>
            <td>${r.category}</td>
            <td><fmt:formatDate value="${r.borrowTime}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${r.dueTime}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${r.returnTime}" pattern="yyyy-MM-dd"/></td>
            <td>${r.status}</td>
            <td>${r.fine}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



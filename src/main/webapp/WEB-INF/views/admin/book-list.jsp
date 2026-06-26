<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>图书管理</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<div class="page-title">
    <h2>图书管理</h2>
    <a class="btn primary" href="${ctx}/admin/book/add">新增图书</a>
</div>
<form class="search-form" method="get" action="${ctx}/admin/books">
    <input type="text" name="keyword" value="${keyword}" placeholder="书名/作者/出版社/编号">
    <input type="text" name="category" value="${category}" placeholder="分类">
    <button class="btn" type="submit">查询</button>
</form>
<table class="table">
    <thead><tr><th>编号</th><th>书名</th><th>作者</th><th>出版社</th><th>分类</th><th>总库存</th><th>可借</th><th>位置</th><th>操作</th></tr></thead>
    <tbody>
    <c:forEach items="${books}" var="book">
        <tr>
            <td>${book.bookNo}</td>
            <td>${book.bookName}</td>
            <td>${book.author}</td>
            <td>${book.publisher}</td>
            <td>${book.category}</td>
            <td>${book.totalCount}</td>
            <td>${book.availableCount}</td>
            <td>${book.location}</td>
            <td>
                <a class="btn small" href="${ctx}/admin/book/edit?id=${book.id}">修改</a>
                <a class="btn small danger" href="${ctx}/admin/book/delete?id=${book.id}" onclick="return confirmDelete('确定下架该图书吗？')">下架</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



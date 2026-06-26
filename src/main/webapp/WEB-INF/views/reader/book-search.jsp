<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>图书查询</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/reader-header.jsp" %>
<h2>图书查询</h2>
<form class="search-form" method="get" action="${ctx}/reader/books">
    <input type="text" name="keyword" value="${keyword}" placeholder="书名/作者/出版社/编号">
    <input type="text" name="category" value="${category}" placeholder="分类">
    <button class="btn" type="submit">查询</button>
</form>
<table class="table">
    <thead><tr><th>编号</th><th>书名</th><th>作者</th><th>出版社</th><th>分类</th><th>可借库存</th><th>位置</th></tr></thead>
    <tbody>
    <c:forEach items="${books}" var="book">
        <tr>
            <td>${book.bookNo}</td>
            <td>${book.bookName}</td>
            <td>${book.author}</td>
            <td>${book.publisher}</td>
            <td>${book.category}</td>
            <td>${book.availableCount}</td>
            <td>${book.location}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>图书表单</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<h2>${action == 'add' ? '新增图书' : '修改图书'}</h2>
<form class="form" method="post" action="${ctx}/admin/book/${action}">
    <input type="hidden" name="id" value="${book.id}">
    <label>图书编号</label>
    <input name="bookNo" value="${book.bookNo}" ${action == 'edit' ? 'readonly' : ''} required>
    <label>书名</label>
    <input name="bookName" value="${book.bookName}" required>
    <label>作者</label>
    <input name="author" value="${book.author}">
    <label>出版社</label>
    <input name="publisher" value="${book.publisher}">
    <label>分类</label>
    <input name="category" value="${book.category}" placeholder="如：计算机类、外语类、管理类">
    <label>总库存</label>
    <input type="number" name="totalCount" value="${book.totalCount}" min="0" required>
    <label>可借库存</label>
    <input type="number" name="availableCount" value="${book.availableCount}" min="0" placeholder="新增时可不填，默认等于总库存">
    <label>馆藏位置</label>
    <input name="location" value="${book.location}" placeholder="如：A-01">
    <button class="btn primary" type="submit">保存</button>
    <a class="btn" href="${ctx}/admin/books">返回</a>
</form>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



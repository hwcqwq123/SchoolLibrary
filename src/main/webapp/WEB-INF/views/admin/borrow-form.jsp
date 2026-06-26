<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>借书登记</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<h2>借书登记</h2>
<c:if test="${not empty error}"><div class="alert error">${error}</div></c:if>
<form class="form" method="post" action="${ctx}/admin/borrow/add">
    <label>选择读者</label>
    <select name="readerId" required>
        <c:forEach items="${readers}" var="reader">
            <option value="${reader.id}">${reader.readerNo} - ${reader.name}</option>
        </c:forEach>
    </select>
    <label>选择图书</label>
    <select name="bookId" required>
        <c:forEach items="${books}" var="book">
            <option value="${book.id}">${book.bookNo} - ${book.bookName}（可借：${book.availableCount}）</option>
        </c:forEach>
    </select>
    <label>借阅天数</label>
    <input type="number" name="borrowDays" value="30" min="1" required>
    <button class="btn primary" type="submit">确认借出</button>
    <a class="btn" href="${ctx}/admin/borrow/list">返回</a>
</form>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



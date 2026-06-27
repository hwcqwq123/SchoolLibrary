<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>借阅记录</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<div class="page-title">
    <h2>借阅记录</h2>
    <a class="btn primary" href="${ctx}/admin/borrow/add">借书登记</a>
</div>
<form class="search-form" method="get" action="${ctx}/admin/borrow/list">
    <input type="text" name="keyword" value="${keyword}" placeholder="读者/图书关键字">
    <select name="status">
        <option value="">全部状态</option>
        <option value="BORROWED" ${status == 'BORROWED' ? 'selected' : ''}>借阅中</option>
        <option value="RETURNED" ${status == 'RETURNED' ? 'selected' : ''}>已归还</option>
        <option value="OVERDUE" ${status == 'OVERDUE' ? 'selected' : ''}>逾期归还</option>
    </select>
    <button class="btn" type="submit">查询</button>
</form>
<table class="table">
    <thead><tr><th>读者</th><th>图书</th><th>借阅时间</th><th>应还时间</th><th>归还时间</th><th>状态</th><th>逾期天数</th><th>罚款</th><th>操作</th></tr></thead>
    <tbody>
    <c:forEach items="${records}" var="r">
        <tr>
            <td>${r.readerNo} / ${r.readerName}</td>
            <td>${r.bookNo} / ${r.bookName}</td>
            <td>${fn:replace(r.borrowTime, 'T', ' ')}</td>
            <td>${fn:replace(r.dueTime, 'T', ' ')}</td>
            <td>${fn:replace(r.returnTime, 'T', ' ')}</td>
            <td>${r.status}</td>
            <td>${r.overdueDays}</td>
            <td>${r.fine}</td>
            <td>
                <c:if test="${r.status == 'BORROWED'}">
                    <a class="btn small primary" href="${ctx}/admin/borrow/return?id=${r.id}" onclick="return confirmDelete('确定归还该图书吗？')">还书</a>
                </c:if>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<%@ include file="../common/footer.jsp" %>
</body>
</html>




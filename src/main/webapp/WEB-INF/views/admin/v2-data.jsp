<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>数据维护 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="data"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>数据维护</h1><p>导入图书数据，导出馆藏和借阅记录。</p></div></div>
    <section class="v2-card"><h2>数据导出</h2><a class="v2-btn primary" href="${pageContext.request.contextPath}/admin/v2/data/export-books">导出图书 CSV</a><a class="v2-btn primary" href="${pageContext.request.contextPath}/admin/v2/data/export-borrows">导出借阅 CSV</a></section>
    <section class="v2-card"><h2>图书导入</h2><p class="v2-muted">CSV 推荐列：bookNo, bookName, author, publisher, categoryId, totalCount, availableCount</p><form class="v2-form three" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/admin/v2/data/import-books"><div><label>CSV 文件</label><input class="v2-input" type="file" name="file" accept=".csv"></div><button class="v2-btn primary" type="submit">上传导入</button></form></section>
</main></div></body></html>

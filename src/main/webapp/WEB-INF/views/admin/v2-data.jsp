<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>数据维护</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head><body class="v2-body"><div class="v2-layout"><jsp:include page="v2-sidebar.jsp"/><main class="v2-main">
<div class="v2-top"><div><h1>数据维护</h1><p>图书导入、图书导出、借阅记录导出。</p></div></div>
<section class="v2-card"><h2>导出数据</h2><a class="v2-btn primary" href="${pageContext.request.contextPath}/admin/v2/data/export-books">导出图书 CSV</a><a class="v2-btn primary" href="${pageContext.request.contextPath}/admin/v2/data/export-borrows">导出借阅 CSV</a></section>
<section class="v2-card"><h2>导入图书</h2><p class="v2-muted">CSV 列顺序：bookNo,bookName,author,publisher,categoryId,totalCount,availableCount</p><form class="v2-form" method="post" action="${pageContext.request.contextPath}/admin/v2/data/import-books" enctype="multipart/form-data"><div><label>CSV 文件</label><input class="v2-input" type="file" name="file" accept=".csv" required></div><button class="v2-btn ok">上传导入</button></form></section>
</main></div></body></html>

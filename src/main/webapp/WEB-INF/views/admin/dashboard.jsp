<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员首页</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<h2>首页统计</h2>
<div class="cards">
    <div class="card"><strong>${stats.bookCount}</strong><span>馆藏图书</span></div>
    <div class="card"><strong>${stats.readerCount}</strong><span>读者数量</span></div>
    <div class="card"><strong>${stats.borrowedCount}</strong><span>当前借出</span></div>
    <div class="card"><strong>${stats.overdueCount}</strong><span>逾期未还</span></div>
</div>
<div class="panel">
    <h3>系统说明</h3>
    <p>管理员可完成图书信息维护、读者信息维护、借阅归还管理和借阅记录查询等功能。</p>
</div>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



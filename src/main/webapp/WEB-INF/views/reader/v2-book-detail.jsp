<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <style>
        .reader-book-detail-grid{display:grid;grid-template-columns:minmax(0,1.1fr) 360px;gap:20px}.reader-status-panel{padding:22px;border-radius:22px;background:#fff;border:1px solid #dbeafe;box-shadow:0 18px 38px rgba(15,23,42,.06)}.reader-status-panel h2{margin:0 0 14px;color:#0f172a;font-size:20px;font-weight:900}.reader-status-list{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}.reader-status-item{padding:14px;border-radius:16px;background:#f8fafc;border:1px solid #e2e8f0}.reader-status-item strong{display:block;margin-bottom:6px;color:#2563eb;font-size:24px;font-weight:950}.reader-status-item span{color:#475569;font-size:13px;font-weight:800}.reader-status-main{margin-top:14px;padding:14px;border-radius:16px;background:#eff6ff;color:#1d4ed8;font-weight:900}.reader-detail-card{padding:24px;border-radius:22px;background:#fff;border:1px solid #dbeafe;box-shadow:0 18px 38px rgba(15,23,42,.06)}.reader-detail-card h1{margin:0 0 18px;color:#0f172a}.reader-detail-row{margin:10px 0;color:#334155}.reader-detail-desc{margin-top:18px;line-height:1.8;color:#475569}.reader-tip{margin-top:16px;color:#64748b;font-size:14px;line-height:1.7}@media(max-width:960px){.reader-book-detail-grid{grid-template-columns:1fr}}
    </style>
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>图书详情</h1>
                <p>读者端仅查询图书状态，如需借阅，请到图书馆服务台由普通管理员办理。</p>
            </div>
            <a class="v2-btn" href="${pageContext.request.contextPath}/reader/v2/books">返回图书查询</a>
        </div>

        <div class="reader-book-detail-grid">
            <section class="reader-detail-card">
                <h1>${book.bookName}</h1>
                <div class="reader-detail-row">编号：${book.bookNo}</div>
                <div class="reader-detail-row">ISBN：${book.isbn}</div>
                <div class="reader-detail-row">作者：${book.author}</div>
                <div class="reader-detail-row">出版社：${book.publisher}</div>
                <div class="reader-detail-row">分类：${book.categoryName}</div>
                <div class="reader-detail-desc">${book.description}</div>
            </section>

            <aside class="reader-status-panel">
                <h2>实体书状态</h2>
                <div class="reader-status-list">
                    <div class="reader-status-item">
                        <strong>${empty book.totalCopyCount ? book.totalCount : book.totalCopyCount}</strong>
                        <span>馆藏总数</span>
                    </div>
                    <div class="reader-status-item">
                        <strong>${empty book.onShelfCount ? book.availableCount : book.onShelfCount}</strong>
                        <span>已上架可借</span>
                    </div>
                    <div class="reader-status-item">
                        <strong>${empty book.borrowedCopyCount ? book.borrowCount : book.borrowedCopyCount}</strong>
                        <span>借出中</span>
                    </div>
                    <div class="reader-status-item">
                        <strong>${empty book.processingCount ? 0 : book.processingCount}</strong>
                        <span>上架中</span>
                    </div>
                </div>
                <div class="reader-status-main">当前状态：${book.displayStatus}</div>
                <div class="reader-tip">“上架中”表示图书已归还但仍在整理，暂时不能借阅。</div>
            </aside>
        </div>
    </main>
</div>
</body>
</html>

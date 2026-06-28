<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>
    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>图书详情</h1>
                <p>${book.bookName}</p>
            </div>
            <a class="v2-btn" href="${pageContext.request.contextPath}/reader/v2/books">返回</a>
        </div>

        <section class="v2-card">
            <h2>${book.bookName}</h2>
            <p>编号：${book.bookNo}</p>
            <p>ISBN：${book.isbn}</p>
            <p>作者：${book.author}</p>
            <p>出版社：${book.publisher}</p>
            <p>分类：${book.categoryName}</p>
            <p>当前状态：${book.displayStatus}</p>

            <div class="v2-book-status">
                <span>馆藏：${empty book.totalCopyCount ? book.totalCount : book.totalCopyCount}</span>
                <span>已上架：${empty book.onShelfCount ? book.availableCount : book.onShelfCount}</span>
                <span>借出中：${empty book.borrowedCopyCount ? book.borrowCount : book.borrowedCopyCount}</span>
                <span>上架中：${empty book.processingCount ? 0 : book.processingCount}</span>
            </div>

            <p class="v2-muted">读者端仅支持查询图书状态。如需借阅，请到图书馆服务台由普通管理员办理。</p>
            <p>${book.description}</p>
        </section>
    </main>
</div>
</body>
</html>

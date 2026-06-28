<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书查询</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>
    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>图书查询</h1>
                <p>读者端仅查询图书状态。如需借阅，请到图书馆服务台由普通管理员办理。</p>
            </div>
        </div>

        <section class="v2-card">
            <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/reader/v2/books">
                <div>
                    <label>关键词</label>
                    <input class="v2-input" name="keyword" value="${keyword}" placeholder="书名 / 编号 / 作者 / 出版社">
                </div>
                <div>
                    <label>分类</label>
                    <select class="v2-select" name="categoryId">
                        <option value="">全部</option>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.id}" ${categoryId == c.id ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label>推荐</label>
                    <select class="v2-select" name="recommend">
                        <option value="">不限</option>
                        <option value="1" ${recommend == 1 ? 'selected' : ''}>只看推荐</option>
                    </select>
                </div>
                <button class="v2-btn primary" type="submit">查询</button>
            </form>
        </section>

        <section class="v2-grid three">
            <c:forEach items="${books}" var="b">
                <article class="v2-card v2-book-card">
                    <h3>${b.bookName}</h3>
                    <p>${b.author}</p>
                    <p>${b.publisher} / ${b.categoryName}</p>
                    <div class="v2-book-status">
                        <span>馆藏 ${empty b.totalCopyCount ? b.totalCount : b.totalCopyCount}</span>
                        <span>已上架 ${empty b.onShelfCount ? b.availableCount : b.onShelfCount}</span>
                        <span>借出中 ${empty b.borrowedCopyCount ? b.borrowCount : b.borrowedCopyCount}</span>
                        <span>上架中 ${empty b.processingCount ? 0 : b.processingCount}</span>
                    </div>
                    <p class="v2-muted">当前状态：${b.displayStatus}</p>
                    <a class="v2-btn" href="${pageContext.request.contextPath}/reader/v2/books/${b.id}">查看详情</a>
                </article>
            </c:forEach>
            <c:if test="${empty books}">
                <div class="v2-card">暂无符合条件的图书</div>
            </c:if>
        </section>
    </main>
</div>
</body>
</html>

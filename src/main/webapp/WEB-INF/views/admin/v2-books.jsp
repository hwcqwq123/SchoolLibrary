<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="books"/></jsp:include>
    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>图书管理</h1>
                <p>统一查看馆藏图书信息、分类、库存与推荐状态。</p>
            </div>
            <span class="v2-tag info">v2 页面</span>
        </div>

        <section class="v2-card">
            <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/books">
                <div>
                    <label>关键词</label>
                    <input class="v2-input" name="keyword" value="${keyword}" placeholder="书名 / 编号 / 作者 / 出版社">
                </div>
                <div>
                    <label>分类</label>
                    <select class="v2-select" name="categoryId">
                        <option value="">全部分类</option>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.id}" ${categoryId == c.id ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <button class="v2-btn primary" type="submit">查询</button>
            </form>
        </section>

        <section class="v2-card">
            <table class="v2-table">
                <tr>
                    <th>编号</th><th>书名</th><th>作者</th><th>出版社</th><th>分类</th><th>库存</th><th>推荐</th>
                </tr>
                <c:forEach items="${books}" var="b">
                    <tr>
                        <td>${b.bookNo}</td>
                        <td><strong>${b.bookName}</strong></td>
                        <td>${b.author}</td>
                        <td>${b.publisher}</td>
                        <td>${b.categoryName}</td>
                        <td>${b.availableCount}/${b.totalCount}</td>
                        <td><c:if test="${b.recommendFlag == 1}"><span class="v2-tag info">推荐</span></c:if></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty books}"><tr><td colspan="7" class="v2-empty">暂无图书数据</td></tr></c:if>
            </table>
        </section>
    </main>
</div>
</body>
</html>

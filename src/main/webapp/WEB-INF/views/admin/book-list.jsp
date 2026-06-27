<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理</title>

    <%-- 【本次修改】引入全局样式文件 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>

<%@ include file="../common/admin-header.jsp" %>

<div class="page-container">

    <%-- 【本次修改】页面头部区域重新设计：标题 + 描述 + 新增按钮 --%>
    <div class="book-page-header">
        <div class="book-page-header-left">
            <h2>图书管理</h2>
            <p>统一管理馆藏图书信息、库存、封面、分类与推荐状态</p>
        </div>
        <div class="book-page-header-right">
            <a class="book-main-btn" href="${pageContext.request.contextPath}/admin/book/add">+ 新增图书</a>
        </div>
    </div>

    <%-- 【本次修改】查询区域重新设计，变成一个独立卡片 --%>
    <div class="book-search-card">
        <form method="get" action="${pageContext.request.contextPath}/admin/books" class="book-search-form">
            <div class="book-search-item">
                <label>关键字</label>
                <input type="text"
                       name="keyword"
                       value="${keyword}"
                       placeholder="请输入编号、书名、作者、出版社、ISBN">
            </div>

            <div class="book-search-item">
                <label>分类</label>
                <input type="text"
                       name="category"
                       value="${category}"
                       placeholder="请输入分类名称">
            </div>

            <div class="book-search-actions">
                <button type="submit" class="book-search-btn">查询</button>
                <a href="${pageContext.request.contextPath}/admin/books" class="book-reset-btn">重置</a>
            </div>
        </form>
    </div>

    <%-- 【本次修改】表格外层卡片，增强层次感和边界感 --%>
    <div class="book-table-card">
        <div class="book-table-topbar">
            <div class="book-table-title">图书列表</div>
            <div class="book-table-subtitle">当前共展示 <strong>${empty books ? 0 : fn:length(books)}</strong> 条图书记录</div>
        </div>

        <div class="book-table-wrapper">
            <table class="book-data-table">
                <thead>
                <tr>
                    <th style="width: 120px;">封面</th>
                    <th style="width: 120px;">编号</th>
                    <th style="min-width: 180px;">书名</th>
                    <th style="width: 120px;">作者</th>
                    <th style="min-width: 140px;">出版社</th>
                    <th style="width: 100px;">分类</th>
                    <th style="width: 90px;">总库存</th>
                    <th style="width: 90px;">可借</th>
                    <th style="width: 100px;">位置</th>
                    <th style="width: 90px;">推荐</th>
                    <th style="width: 150px;">操作</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${books}" var="book">
                    <tr>
                        <td>
                            <div class="book-cover-cell">
                                <c:choose>
                                    <c:when test="${not empty book.coverImage}">
                                        <img src="${pageContext.request.contextPath}${book.coverImage}"
                                             alt="图书封面"
                                             class="book-cover-thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/img/default-book.svg"
                                             alt="默认封面"
                                             class="book-cover-thumb">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>

                        <td class="book-col-code">${book.bookNo}</td>
                        <td class="book-col-name">${book.bookName}</td>
                        <td>${book.author}</td>
                        <td>${book.publisher}</td>
                        <td>${book.category}</td>
                        <td>${book.totalCount}</td>
                        <td>${book.availableCount}</td>
                        <td>${book.location}</td>

                        <td>
                            <c:choose>
                                <c:when test="${book.recommendFlag == 1}">
                                    <span class="book-tag recommend">推荐</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="book-tag normal">普通</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <%-- 【本次修改】操作按钮重新设计：高光、圆角、区分主次 --%>
                            <div class="book-action-group">
                                <a href="${pageContext.request.contextPath}/admin/book/edit?id=${book.id}"
                                   class="book-action-btn edit-btn">修改</a>

                                <a href="${pageContext.request.contextPath}/admin/book/delete?id=${book.id}"
                                   class="book-action-btn delete-btn"
                                   onclick="return confirm('确定要下架这本图书吗？');">下架</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty books}">
                    <tr>
                        <td colspan="11" class="book-empty-cell">暂无图书数据</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

</body>
</html>
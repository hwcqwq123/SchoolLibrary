<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书查询</title>
</head>
<body>

<%@ include file="../common/reader-header.jsp" %>

<div class="page-container">
    <h2>图书查询</h2>

    <form method="get" action="${pageContext.request.contextPath}/reader/books" class="search-box">
        <input type="text" name="keyword" value="${keyword}" placeholder="编号、书名、作者、出版社、ISBN">
        <input type="text" name="category" value="${category}" placeholder="分类">
        <button type="submit">查询</button>
    </form>

    <table class="data-table" border="1" cellspacing="0" cellpadding="8">
        <thead>
        <tr>
            <!-- 【本次修改】新增封面列 -->
            <th>封面</th>
            <th>编号</th>
            <th>书名</th>
            <th>作者</th>
            <th>出版社</th>
            <th>分类</th>
            <th>可借库存</th>
            <th>位置</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${books}" var="book">
            <tr>
                <!-- 【本次修改】显示图书封面 -->
                <td>
                    <c:choose>
                        <c:when test="${not empty book.coverImage}">
                            <img src="${pageContext.request.contextPath}${book.coverImage}"
                                 alt="图书封面"
                                 style="width: 52px; height: 70px; object-fit: cover; border: 1px solid #ddd;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default-book.svg"
                                 alt="默认封面"
                                 style="width: 52px; height: 70px; object-fit: cover; border: 1px solid #ddd;">
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>${book.bookNo}</td>
                <td>${book.bookName}</td>
                <td>${book.author}</td>
                <td>${book.publisher}</td>
                <td>${book.category}</td>
                <td>${book.availableCount}</td>
                <td>${book.location}</td>
            </tr>
        </c:forEach>

        <c:if test="${empty books}">
            <tr>
                <td colspan="8">暂无图书数据</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<%@ include file="../common/footer.jsp" %>

</body>
</html>
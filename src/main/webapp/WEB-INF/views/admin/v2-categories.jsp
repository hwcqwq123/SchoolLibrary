<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分类管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="categories"/></jsp:include>
    <main class="v2-main">
        <div class="v2-page-head"><div><h1>分类管理</h1><p>分类新增、修改、禁用与馆藏统计。</p></div></div>
        <section class="v2-card">
            <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/categories">
                <div><label>关键词</label><input class="v2-input" name="keyword" value="${keyword}" placeholder="分类名称"></div>
                <button class="v2-btn primary" type="submit">查询</button>
            </form>
        </section>
        <section class="v2-card">
            <h2>新增分类</h2>
            <form class="v2-form three" method="post" action="${pageContext.request.contextPath}/admin/v2/categories/add">
                <div><label>分类名称</label><input class="v2-input" name="categoryName" required></div>
                <div><label>说明</label><input class="v2-input" name="description"></div>
                <button class="v2-btn primary" type="submit">新增</button>
            </form>
        </section>
        <section class="v2-card">
            <table class="v2-table">
                <tr><th>ID</th><th>名称</th><th>说明</th><th>图书数</th><th>状态</th><th>修改</th><th>操作</th></tr>
                <c:forEach items="${list}" var="c">
                    <tr>
                        <td>${c.id}</td><td>${c.categoryName}</td><td>${c.description}</td><td>${c.bookCount}</td>
                        <td><span class="v2-tag ${c.status == 1 ? 'ok' : 'danger'}">${c.status == 1 ? '启用' : '禁用'}</span></td>
                        <td>
                            <form class="v2-form three" method="post" action="${pageContext.request.contextPath}/admin/v2/categories/update">
                                <input type="hidden" name="id" value="${c.id}">
                                <input class="v2-input" name="categoryName" value="${c.categoryName}">
                                <input class="v2-input" name="description" value="${c.description}">
                                <select class="v2-select" name="status"><option value="1" ${c.status == 1 ? 'selected' : ''}>启用</option><option value="0" ${c.status == 0 ? 'selected' : ''}>禁用</option></select>
                                <button class="v2-btn ok" type="submit">保存</button>
                            </form>
                        </td>
                        <td><a class="v2-btn danger" href="${pageContext.request.contextPath}/admin/v2/categories/disable/${c.id}" onclick="return confirm('确认禁用该分类？')">禁用</a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}"><tr><td colspan="7" class="v2-empty">暂无分类数据</td></tr></c:if>
            </table>
        </section>
    </main>
</div>
</body>
</html>

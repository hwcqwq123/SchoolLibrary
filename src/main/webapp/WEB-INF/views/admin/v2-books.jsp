<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>v2 图书管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <style>
        body { margin:0; font-family:"Microsoft YaHei", Arial, sans-serif; background:#f3f6fb; color:#1f2937; }
        .v2-wrap { max-width:1200px; margin:0 auto; padding:28px; }
        .v2-nav { display:flex; flex-wrap:wrap; gap:10px; margin-bottom:22px; }
        .v2-nav a { text-decoration:none; padding:10px 14px; border-radius:10px; background:#fff; color:#334155; border:1px solid #dbe4f0; font-weight:700; }
        .v2-nav a.active { background:#2563eb; color:#fff; border-color:#2563eb; }
        .card { background:#fff; border-radius:18px; padding:22px; box-shadow:0 12px 32px rgba(15,23,42,.08); border:1px solid #e5eaf3; margin-bottom:18px; }
        .header { display:flex; justify-content:space-between; align-items:center; gap:16px; }
        .header h1 { margin:0; font-size:26px; }
        .search { display:flex; gap:10px; flex-wrap:wrap; margin-top:18px; }
        .search input, .search select { height:40px; border:1px solid #cbd5e1; border-radius:10px; padding:0 12px; }
        .btn { border:none; border-radius:10px; padding:10px 16px; background:#2563eb; color:#fff; font-weight:800; cursor:pointer; text-decoration:none; display:inline-block; }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; font-size:14px; }
        th { background:#f8fafc; color:#475569; }
        tr:hover { background:#f8fbff; }
        .muted { color:#64748b; }
        .tag { display:inline-block; padding:4px 8px; border-radius:999px; background:#e0f2fe; color:#0369a1; font-size:12px; font-weight:700; }
    </style>
</head>
<body>
<div class="v2-wrap">
    <div class="v2-nav">
        <a href="${pageContext.request.contextPath}/admin/v2/dashboard">首页</a>
        <a class="active" href="${pageContext.request.contextPath}/admin/v2/books">图书管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/readers">读者管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/borrows">借阅概览</a>
        <a href="${pageContext.request.contextPath}/admin/v2/categories">分类管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/renews">续借审核</a>
        <a href="${pageContext.request.contextPath}/admin/v2/fines">罚款管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/seats">座位管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/notices">公告管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/data">数据维护</a>
        <a href="${pageContext.request.contextPath}/admin/v2/system">系统管理</a>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>

    <div class="card header">
        <div>
            <h1>图书管理</h1>
            <div class="muted">新版 v2 图书概览，避免跳回旧页面。</div>
        </div>
        <a class="btn" href="${pageContext.request.contextPath}/admin/books/add">新增图书</a>
    </div>

    <div class="card">
        <form class="search" method="get" action="${pageContext.request.contextPath}/admin/v2/books">
            <input type="text" name="keyword" value="${keyword}" placeholder="书名 / 编号 / 作者">
            <select name="categoryId">
                <option value="">全部分类</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}" ${categoryId == c.id ? 'selected' : ''}>${c.categoryName}</option>
                </c:forEach>
            </select>
            <button class="btn" type="submit">查询</button>
        </form>
    </div>

    <div class="card">
        <table>
            <thead>
            <tr>
                <th>编号</th>
                <th>书名</th>
                <th>作者</th>
                <th>出版社</th>
                <th>分类</th>
                <th>库存</th>
                <th>推荐</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${books}" var="b">
                <tr>
                    <td>${b.bookNo}</td>
                    <td><strong>${b.bookName}</strong></td>
                    <td>${b.author}</td>
                    <td>${b.publisher}</td>
                    <td>${b.categoryName}</td>
                    <td>${b.availableCount}/${b.totalCount}</td>
                    <td><c:if test="${b.recommendFlag == 1}"><span class="tag">推荐</span></c:if></td>
                    <td><a class="btn" href="${pageContext.request.contextPath}/admin/books/edit/${b.id}">编辑</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty books}">
                <tr><td colspan="8" class="muted">暂无图书数据</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

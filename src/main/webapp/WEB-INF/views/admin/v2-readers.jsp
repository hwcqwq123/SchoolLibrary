<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>v2 读者管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <style>
        body { margin:0; font-family:"Microsoft YaHei", Arial, sans-serif; background:#f3f6fb; color:#1f2937; }
        .v2-wrap { max-width:1200px; margin:0 auto; padding:28px; }
        .v2-nav { display:flex; flex-wrap:wrap; gap:10px; margin-bottom:22px; }
        .v2-nav a { text-decoration:none; padding:10px 14px; border-radius:10px; background:#fff; color:#334155; border:1px solid #dbe4f0; font-weight:700; }
        .v2-nav a.active { background:#2563eb; color:#fff; border-color:#2563eb; }
        .card { background:#fff; border-radius:18px; padding:22px; box-shadow:0 12px 32px rgba(15,23,42,.08); border:1px solid #e5eaf3; margin-bottom:18px; }
        h1 { margin:0; font-size:26px; }
        .muted { color:#64748b; }
        .search { display:flex; gap:10px; flex-wrap:wrap; margin-top:18px; }
        .search input { height:40px; border:1px solid #cbd5e1; border-radius:10px; padding:0 12px; }
        .btn { border:none; border-radius:10px; padding:10px 16px; background:#2563eb; color:#fff; font-weight:800; cursor:pointer; text-decoration:none; display:inline-block; }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; font-size:14px; }
        th { background:#f8fafc; color:#475569; }
        tr:hover { background:#f8fbff; }
    </style>
</head>
<body>
<div class="v2-wrap">
    <div class="v2-nav">
        <a href="${pageContext.request.contextPath}/admin/v2/dashboard">首页</a>
        <a href="${pageContext.request.contextPath}/admin/v2/books">图书管理</a>
        <a class="active" href="${pageContext.request.contextPath}/admin/v2/readers">读者管理</a>
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

    <div class="card">
        <h1>读者管理</h1>
        <div class="muted">新版 v2 读者概览，旧入口 /admin/readers 会自动跳转到这里。</div>
        <form class="search" method="get" action="${pageContext.request.contextPath}/admin/v2/readers">
            <input type="text" name="keyword" value="${keyword}" placeholder="姓名 / 学号 / 学院 / 手机">
            <button class="btn" type="submit">查询</button>
        </form>
    </div>

    <div class="card">
        <table>
            <thead>
            <tr>
                <th>读者号</th>
                <th>用户名</th>
                <th>姓名</th>
                <th>学号</th>
                <th>学院</th>
                <th>专业</th>
                <th>班级</th>
                <th>手机</th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${readers}" var="r">
                <tr>
                    <td>${r.readerNo}</td>
                    <td>${r.username}</td>
                    <td><strong>${r.name}</strong></td>
                    <td>${r.studentNo}</td>
                    <td>${r.college}</td>
                    <td>${r.major}</td>
                    <td>${r.className}</td>
                    <td>${r.phone}</td>
                    <td>${r.status == 1 ? '启用' : '禁用'}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty readers}">
                <tr><td colspan="9" class="muted">暂无读者数据</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

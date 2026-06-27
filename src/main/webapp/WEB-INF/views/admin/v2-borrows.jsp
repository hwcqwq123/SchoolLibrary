<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>v2 借阅概览</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <style>
        body { margin:0; font-family:"Microsoft YaHei", Arial, sans-serif; background:#f3f6fb; color:#1f2937; }
        .v2-wrap { max-width:1200px; margin:0 auto; padding:28px; }
        .v2-nav { display:flex; flex-wrap:wrap; gap:10px; margin-bottom:22px; }
        .v2-nav a { text-decoration:none; padding:10px 14px; border-radius:10px; background:#fff; color:#334155; border:1px solid #dbe4f0; font-weight:700; }
        .v2-nav a.active { background:#2563eb; color:#fff; border-color:#2563eb; }
        .card { background:#fff; border-radius:18px; padding:22px; box-shadow:0 12px 32px rgba(15,23,42,.08); border:1px solid #e5eaf3; margin-bottom:18px; }
        h1, h2 { margin:0 0 12px; }
        .muted { color:#64748b; }
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
        <a href="${pageContext.request.contextPath}/admin/v2/readers">读者管理</a>
        <a class="active" href="${pageContext.request.contextPath}/admin/v2/borrows">借阅概览</a>
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
        <h1>借阅概览</h1>
        <div class="muted">旧入口 /admin/borrows 会自动跳转到这里，避免 404。</div>
    </div>

    <div class="card">
        <h2>最近借阅</h2>
        <table>
            <thead>
            <tr>
                <th>读者</th>
                <th>图书</th>
                <th>借出时间</th>
                <th>应还时间</th>
                <th>归还时间</th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${recentBorrows}" var="b">
                <tr>
                    <td>${b.readerName}</td>
                    <td>${b.bookName}</td>
                    <td>${b.borrowDate}</td>
                    <td>${b.dueDate}</td>
                    <td>${b.returnDate}</td>
                    <td>${b.status}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty recentBorrows}">
                <tr><td colspan="6" class="muted">暂无借阅记录</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h2>逾期提醒</h2>
        <table>
            <thead>
            <tr>
                <th>读者</th>
                <th>图书</th>
                <th>应还日期</th>
                <th>逾期天数</th>
                <th>预计罚款</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${overdueList}" var="o">
                <tr>
                    <td>${o.readerName}</td>
                    <td>${o.bookName}</td>
                    <td>${o.dueDate}</td>
                    <td>${o.overdueDays}</td>
                    <td>${o.fine}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty overdueList}">
                <tr><td colspan="5" class="muted">暂无逾期记录</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

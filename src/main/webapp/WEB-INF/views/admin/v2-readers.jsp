<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>读者管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="readers"/></jsp:include>
    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>读者管理</h1>
                <p>查看读者账号、学号、学院、专业、联系方式与账号状态。</p>
            </div>
            <span class="v2-tag info">v2 页面</span>
        </div>

        <section class="v2-card">
            <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/readers">
                <div>
                    <label>关键词</label>
                    <input class="v2-input" name="keyword" value="${keyword}" placeholder="姓名 / 学号 / 学院 / 手机">
                </div>
                <button class="v2-btn primary" type="submit">查询</button>
            </form>
        </section>

        <section class="v2-card">
            <table class="v2-table">
                <tr><th>读者号</th><th>用户名</th><th>姓名</th><th>学号</th><th>学院</th><th>专业</th><th>班级</th><th>手机</th><th>状态</th></tr>
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
                        <td><span class="v2-tag ${r.status == 1 ? 'ok' : 'danger'}">${r.status == 1 ? '启用' : '禁用'}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty readers}"><tr><td colspan="9" class="v2-empty">暂无读者数据</td></tr></c:if>
            </table>
        </section>
    </main>
</div>
</body>
</html>

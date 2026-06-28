<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作日志 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2-business.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="v2-top">
            <div>
                <h1>操作日志</h1>
                <p>超级管理员查看普通管理员和系统关键操作记录。</p>
            </div>
        </div>

        <section class="v2-card">
            <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/logs">
                <div>
                    <label>关键词</label>
                    <input class="v2-input" name="keyword" value="${keyword}" placeholder="操作人 / 操作内容 / URL">
                </div>
                <div>
                    <label>模块</label>
                    <select class="v2-select" name="module">
                        <option value="">全部模块</option>
                        <option value="ADMIN_MANAGE" ${module == 'ADMIN_MANAGE' ? 'selected' : ''}>管理员管理</option>
                        <option value="BORROW" ${module == 'BORROW' ? 'selected' : ''}>借阅管理</option>
                        <option value="BOOK" ${module == 'BOOK' ? 'selected' : ''}>图书管理</option>
                        <option value="READER" ${module == 'READER' ? 'selected' : ''}>读者管理</option>
                        <option value="FINE" ${module == 'FINE' ? 'selected' : ''}>罚款管理</option>
                    </select>
                </div>
                <button class="v2-btn primary" type="submit">查询日志</button>
            </form>
        </section>

        <section class="v2-card">
            <h2>日志列表</h2>
            <table class="v2-table">
                <thead>
                <tr>
                    <th>时间</th>
                    <th>操作人</th>
                    <th>模块</th>
                    <th>操作</th>
                    <th>路径</th>
                    <th>IP</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${logs}" var="l">
                    <tr>
                        <td>${fn:replace(l.createTime, 'T', ' ')}</td>
                        <td>${l.operatorName}</td>
                        <td><span class="v2-tag">${l.module}</span></td>
                        <td>${l.operation}</td>
                        <td>${l.requestUrl}</td>
                        <td>${l.ip}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty logs}">
                    <tr><td colspan="6" class="v2-empty">暂无操作日志</td></tr>
                </c:if>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>

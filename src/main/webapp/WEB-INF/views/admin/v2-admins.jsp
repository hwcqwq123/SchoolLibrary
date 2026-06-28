<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2-business.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="v2-top">
            <div>
                <h1>管理员管理</h1>
                <p>超级管理员固定唯一账号为 admin，只负责管理普通管理员账号；读者、借阅等业务由普通管理员负责。</p>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="v2-alert ok">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="v2-alert danger">${param.error}</div>
        </c:if>

        <section class="v2-super-hero">
            <div>
                <h2>超级管理员职责</h2>
                <p>admin 是唯一超级管理员账号，定位为“管理员的管理员”。它可以新增、禁用、启用、重置普通管理员账号，但不直接管理读者账号，也不办理借书和还书。</p>
            </div>
            <div class="v2-super-card">
                <strong>${fn:length(admins)}</strong>
                <span>普通管理员账号</span>
            </div>
        </section>

        <section class="v2-card">
            <h2>新增普通管理员</h2>
            <form class="v2-form" method="post" action="${pageContext.request.contextPath}/admin/v2/admins/add">
                <div>
                    <label>用户名</label>
                    <input class="v2-input" name="username" placeholder="例如：lib001" required>
                </div>
                <div>
                    <label>姓名</label>
                    <input class="v2-input" name="realName" placeholder="例如：李管理员" required>
                </div>
                <div>
                    <label>手机号</label>
                    <input class="v2-input" name="phone" placeholder="可选">
                </div>
                <div>
                    <label>邮箱</label>
                    <input class="v2-input" name="email" placeholder="可选">
                </div>
                <div>
                    <label>初始密码</label>
                    <input class="v2-input" name="password" placeholder="不填默认 123456">
                </div>
                <button class="v2-btn primary" type="submit">新增普通管理员</button>
            </form>
        </section>

        <section class="v2-card">
            <div class="v2-card-headline">
                <h2>普通管理员列表</h2>
                <form class="v2-inline-search" method="get" action="${pageContext.request.contextPath}/admin/v2/admins">
                    <input class="v2-input" name="keyword" value="${keyword}" placeholder="用户名 / 姓名 / 手机 / 邮箱">
                    <button class="v2-btn primary" type="submit">查询</button>
                </form>
            </div>

            <table class="v2-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>手机号</th>
                    <th>邮箱</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${admins}" var="a">
                    <tr>
                        <td>${a.id}</td>
                        <td><strong>${a.username}</strong></td>
                        <td>${a.realName}</td>
                        <td>${a.phone}</td>
                        <td>${a.email}</td>
                        <td>
                            <c:choose>
                                <c:when test="${a.status == 1}"><span class="v2-tag ok">启用</span></c:when>
                                <c:otherwise><span class="v2-tag danger">禁用</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${fn:replace(a.createTime, 'T', ' ')}</td>
                        <td class="v2-actions">
                            <form class="v2-inline-form" method="post" action="${pageContext.request.contextPath}/admin/v2/admins/${a.id}/reset-password" onsubmit="return confirm('确认重置该普通管理员密码？')">
                                <input type="hidden" name="password" value="123456">
                                <button class="v2-btn warn" type="submit">重置密码</button>
                            </form>

                            <c:choose>
                                <c:when test="${a.status == 1}">
                                    <form class="v2-inline-form" method="post" action="${pageContext.request.contextPath}/admin/v2/admins/${a.id}/status" onsubmit="return confirm('确认禁用该普通管理员？')">
                                        <input type="hidden" name="status" value="0">
                                        <button class="v2-btn danger" type="submit">禁用</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form class="v2-inline-form" method="post" action="${pageContext.request.contextPath}/admin/v2/admins/${a.id}/status">
                                        <input type="hidden" name="status" value="1">
                                        <button class="v2-btn ok" type="submit">启用</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty admins}">
                    <tr><td colspan="8" class="v2-empty">暂无普通管理员账号</td></tr>
                </c:if>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>

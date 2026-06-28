<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<%--
    【本次修改】管理员端统一侧边栏，按角色动态显示菜单。

    SUPER_ADMIN：固定唯一 admin，只管理普通管理员、系统维护和日志。
    ADMIN：普通管理员，负责图书、读者、借阅、罚款、座位等业务。
--%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="uri" value="${pageContext.request.requestURI}"/>
<c:set var="role" value="${sessionScope.adminRole}"/>

<aside class="v2-side">
    <div class="v2-brand">
        图书馆管理系统
        <small>
            <c:choose>
                <c:when test="${role == 'SUPER_ADMIN'}">超级管理员 · admin</c:when>
                <c:otherwise>普通管理员 · SchoolLibrary v2</c:otherwise>
            </c:choose>
        </small>
    </div>

    <nav class="v2-nav">
        <c:choose>
            <c:when test="${role == 'SUPER_ADMIN'}">
                <a href="${ctx}/admin/v2/admins" class="${fn:contains(uri, '/admin/v2/admins') ? 'active' : ''}">管理员管理</a>
                <a href="${ctx}/admin/v2/logs" class="${fn:contains(uri, '/admin/v2/logs') ? 'active' : ''}">操作日志</a>
                <a href="${ctx}/admin/v2/data" class="${fn:contains(uri, '/admin/v2/data') ? 'active' : ''}">数据维护</a>
                <a href="${ctx}/admin/v2/system" class="${fn:contains(uri, '/admin/v2/system') ? 'active' : ''}">系统设置</a>
                <a href="${ctx}/logout">退出登录</a>
            </c:when>
            <c:otherwise>
                <a href="${ctx}/admin/v2/dashboard" class="${fn:contains(uri, '/admin/v2/dashboard') ? 'active' : ''}">首页看板</a>
                <a href="${ctx}/admin/v2/books" class="${fn:contains(uri, '/admin/v2/books') ? 'active' : ''}">图书管理</a>
                <a href="${ctx}/admin/v2/categories" class="${fn:contains(uri, '/admin/v2/categories') ? 'active' : ''}">分类管理</a>
                <a href="${ctx}/admin/v2/readers" class="${fn:contains(uri, '/admin/v2/readers') ? 'active' : ''}">读者管理</a>
                <a href="${ctx}/admin/v2/borrows" class="${fn:contains(uri, '/admin/v2/borrows') ? 'active' : ''}">借阅管理</a>
                <a href="${ctx}/admin/v2/renews" class="${fn:contains(uri, '/admin/v2/renews') ? 'active' : ''}">续借审核</a>
                <a href="${ctx}/admin/v2/fines" class="${fn:contains(uri, '/admin/v2/fines') ? 'active' : ''}">罚款管理</a>
                <a href="${ctx}/admin/v2/seats" class="${fn:contains(uri, '/admin/v2/seats') ? 'active' : ''}">座位预约</a>
                <a href="${ctx}/admin/v2/notices" class="${fn:contains(uri, '/admin/v2/notices') ? 'active' : ''}">公告管理</a>
                <a href="${ctx}/logout">退出登录</a>
            </c:otherwise>
        </c:choose>
    </nav>
</aside>

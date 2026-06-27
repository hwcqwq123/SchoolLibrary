<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<%--
    【本次修改】管理员端统一侧边栏。
    选中效果统一为浅蓝色按钮，依赖 v2.css 的 .v2-nav a.active。
--%>
<aside class="v2-side">
    <div class="v2-brand">
        图书馆管理系统
        <small>管理员端 · SchoolLibrary v2</small>
    </div>

    <nav class="v2-nav">
        <a class="${param.active == 'dashboard' ? 'active' : ''}" ${param.active == 'dashboard' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/dashboard">首页统计</a>
        <a class="${param.active == 'books' ? 'active' : ''}" ${param.active == 'books' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/books">图书管理</a>
        <a class="${param.active == 'readers' ? 'active' : ''}" ${param.active == 'readers' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/readers">读者管理</a>
        <a class="${param.active == 'borrows' ? 'active' : ''}" ${param.active == 'borrows' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/borrows">借阅概览</a>
        <a class="${param.active == 'categories' ? 'active' : ''}" ${param.active == 'categories' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/categories">分类管理</a>
        <a class="${param.active == 'renews' ? 'active' : ''}" ${param.active == 'renews' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/renews">续借审核</a>
        <a class="${param.active == 'fines' ? 'active' : ''}" ${param.active == 'fines' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/fines">罚款管理</a>
        <a class="${param.active == 'seats' ? 'active' : ''}" ${param.active == 'seats' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/seats">座位预约管理</a>
        <a class="${param.active == 'notices' ? 'active' : ''}" ${param.active == 'notices' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/notices">公告管理</a>
        <a class="${param.active == 'data' ? 'active' : ''}" ${param.active == 'data' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/data">数据维护</a>
        <a class="${param.active == 'system' ? 'active' : ''}" ${param.active == 'system' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/admin/v2/system">系统管理</a>
        <a class="logout" href="${pageContext.request.contextPath}/logout">退出登录</a>
    </nav>
</aside>

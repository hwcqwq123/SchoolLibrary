<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<%--
    【本次修改】读者端统一侧边栏。
    选中效果与管理员端一致：浅蓝色按钮 + 深蓝文字。
--%>
<aside class="v2-side">
    <div class="v2-brand">
        图书馆管理系统
        <small>读者端 · SchoolLibrary v2</small>
    </div>

    <nav class="v2-nav">
        <a class="${param.active == 'home' ? 'active' : ''}" ${param.active == 'home' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/reader/v2/home">读者首页</a>
        <a class="${param.active == 'books' ? 'active' : ''}" ${param.active == 'books' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/reader/v2/books">图书查询</a>
        <a class="${param.active == 'borrows' ? 'active' : ''}" ${param.active == 'borrows' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/reader/v2/borrows">我的借阅</a>
        <a class="${param.active == 'seats' ? 'active' : ''}" ${param.active == 'seats' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/reader/v2/seats">座位预约</a>
        <a class="${param.active == 'profile' ? 'active' : ''}" ${param.active == 'profile' ? 'aria-current="page"' : ''} href="${pageContext.request.contextPath}/reader/v2/profile">个人中心</a>
        <a class="logout" href="${pageContext.request.contextPath}/logout">退出登录</a>
    </nav>
</aside>

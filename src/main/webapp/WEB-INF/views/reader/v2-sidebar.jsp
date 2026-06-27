<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String uri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="v2-side v2-reader-side">
    <div class="v2-brand">
        图书馆读者端
        <small>SchoolLibrary v2 · Reader</small>
    </div>

    <nav class="v2-nav">
        <a class="<%= uri.contains("/reader/v2/home") ? "active" : "" %>" <%= uri.contains("/reader/v2/home") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/reader/v2/home">读者首页</a>
        <a class="<%= uri.contains("/reader/v2/books") ? "active" : "" %>" <%= uri.contains("/reader/v2/books") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/reader/v2/books">图书查询</a>
        <a class="<%= uri.contains("/reader/v2/borrows") ? "active" : "" %>" <%= uri.contains("/reader/v2/borrows") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/reader/v2/borrows">我的借阅</a>
        <a class="<%= uri.contains("/reader/v2/seats") ? "active" : "" %>" <%= uri.contains("/reader/v2/seats") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/reader/v2/seats">座位预约</a>
        <a class="<%= uri.contains("/reader/v2/profile") ? "active" : "" %>" <%= uri.contains("/reader/v2/profile") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/reader/v2/profile">个人中心</a>
        <a href="<%= ctx %>/logout">退出登录</a>
    </nav>
</aside>
<jsp:include page="../common/v2-flash.jsp"/>

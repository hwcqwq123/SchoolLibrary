<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String uri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="v2-side">
    <div class="v2-brand">
        图书馆管理系统
        <small>SchoolLibrary v2 · 管理员端</small>
    </div>

    <nav class="v2-nav">
        <a class="<%= uri.contains("/admin/v2/dashboard") ? "active" : "" %>" <%= uri.contains("/admin/v2/dashboard") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/dashboard">首页看板</a>
        <a class="<%= uri.contains("/admin/v2/books") ? "active" : "" %>" <%= uri.contains("/admin/v2/books") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/books">图书管理</a>
        <a class="<%= uri.contains("/admin/v2/categories") ? "active" : "" %>" <%= uri.contains("/admin/v2/categories") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/categories">分类管理</a>
        <a class="<%= uri.contains("/admin/v2/readers") ? "active" : "" %>" <%= uri.contains("/admin/v2/readers") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/readers">读者管理</a>
        <a class="<%= uri.contains("/admin/v2/borrows") ? "active" : "" %>" <%= uri.contains("/admin/v2/borrows") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/borrows">借阅管理</a>
        <a class="<%= uri.contains("/admin/v2/renews") ? "active" : "" %>" <%= uri.contains("/admin/v2/renews") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/renews">续借审核</a>
        <a class="<%= uri.contains("/admin/v2/fines") ? "active" : "" %>" <%= uri.contains("/admin/v2/fines") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/fines">罚款管理</a>
        <a class="<%= uri.contains("/admin/v2/seats") ? "active" : "" %>" <%= uri.contains("/admin/v2/seats") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/seats">座位预约</a>
        <a class="<%= uri.contains("/admin/v2/notices") ? "active" : "" %>" <%= uri.contains("/admin/v2/notices") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/notices">公告管理</a>
        <a class="<%= uri.contains("/admin/v2/data") ? "active" : "" %>" <%= uri.contains("/admin/v2/data") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/data">数据维护</a>
        <a class="<%= uri.contains("/admin/v2/system") ? "active" : "" %>" <%= uri.contains("/admin/v2/system") ? "aria-current=\"page\"" : "" %> href="<%= ctx %>/admin/v2/system">系统管理</a>
        <a href="<%= ctx %>/logout">退出登录</a>
    </nav>
</aside>
<jsp:include page="../common/v2-flash.jsp"/>

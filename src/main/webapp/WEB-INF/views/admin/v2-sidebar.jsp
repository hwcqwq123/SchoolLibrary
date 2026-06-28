<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    【本次修改】管理员端侧边栏按角色显示。
    SUPER_ADMIN：只显示管理员管理、操作日志、数据维护、系统设置、退出登录。
    ADMIN：只显示业务菜单：首页、图书、分类、读者、借阅、续借、罚款、座位、公告、退出登录。
--%>
<%
    String ctx = request.getContextPath();
    String uri = request.getRequestURI();

    Object roleObj = session.getAttribute("adminRole");
    String adminRole = roleObj == null ? "" : String.valueOf(roleObj);

    boolean isSuperAdmin = "SUPER_ADMIN".equals(adminRole);
    boolean isNormalAdmin = "ADMIN".equals(adminRole);

    /*
     * 容错：
     * 如果旧 session 暂时没有 adminRole，但已经进了管理员端，为避免显示两套菜单，
     * 默认按普通管理员处理。
     */
    if (!isSuperAdmin && !isNormalAdmin) {
        isNormalAdmin = true;
    }
%>

<aside class="v2-side">
    <div class="v2-brand">
        图书馆管理系统
        <% if (isSuperAdmin) { %>
            <small>超级管理员 · admin</small>
        <% } else { %>
            <small>普通管理员 · SchoolLibrary v2</small>
        <% } %>
    </div>

    <nav class="v2-nav">
        <% if (isSuperAdmin) { %>
            <a class="<%= uri.contains("/admin/v2/admins") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/admins">管理员管理</a>

            <a class="<%= uri.contains("/admin/v2/logs") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/logs">操作日志</a>

            <a class="<%= uri.contains("/admin/v2/data") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/data">数据维护</a>

            <a class="<%= uri.contains("/admin/v2/system") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/system">系统设置</a>

            <a href="<%= ctx %>/logout">退出登录</a>
        <% } else { %>
            <a class="<%= uri.contains("/admin/v2/dashboard") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/dashboard">首页看板</a>

            <a class="<%= uri.contains("/admin/v2/books") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/books">图书管理</a>

            <a class="<%= uri.contains("/admin/v2/categories") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/categories">分类管理</a>

            <a class="<%= uri.contains("/admin/v2/readers") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/readers">读者管理</a>

            <a class="<%= uri.contains("/admin/v2/borrows") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/borrows">借阅管理</a>

            <a class="<%= uri.contains("/admin/v2/renews") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/renews">续借审核</a>

            <a class="<%= uri.contains("/admin/v2/fines") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/fines">罚款管理</a>

            <a class="<%= uri.contains("/admin/v2/seats") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/seats">座位预约</a>

            <a class="<%= uri.contains("/admin/v2/notices") ? "active" : "" %>"
               href="<%= ctx %>/admin/v2/notices">公告管理</a>

            <a href="<%= ctx %>/logout">退出登录</a>
        <% } %>
    </nav>
</aside>

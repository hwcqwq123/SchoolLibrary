<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    /*
     * 【本次修改】
     * 原因：
     * 如果直接写 response.sendRedirect("/login")，
     * 浏览器会跳到 http://localhost:8080/login，
     * 这样会丢失项目名 SchoolLibrary，导致 /login 不可用。
     *
     * 正确做法：
     * 必须拼接 request.getContextPath()，
     * 也就是跳转到 /SchoolLibrary/login。
     */
    response.sendRedirect(request.getContextPath() + "/login");
%>
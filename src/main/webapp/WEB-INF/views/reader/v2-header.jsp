<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
    【本次修改】
    读者端旧 v2-header.jsp 兼容文件。
    以前部分 v2 页面引用的是 v2-header.jsp，导致侧边栏标题显示“读者中心”。
    现在统一转发到 v2-sidebar.jsp，避免不同页面侧边栏不一致。
--%>
<jsp:include page="v2-sidebar.jsp"/>
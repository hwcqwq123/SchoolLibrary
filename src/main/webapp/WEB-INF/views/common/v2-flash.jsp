<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="taglib.jsp" %>

<%--
    【本次新增】v2 全局结果提示。
    Controller 重定向时带 success 或 error 参数即可自动展示。
--%>
<c:if test="${not empty param.success}">
    <div class="v2-flash v2-flash-success">
        <strong>操作成功</strong>
        <span>${param.success}</span>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="v2-flash v2-flash-error">
        <strong>操作失败</strong>
        <span>${param.error}</span>
    </div>
</c:if>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>罚款管理 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="fines"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>罚款管理</h1><p>逾期罚款生成、查询与缴费确认。</p></div><a class="v2-btn primary" href="${pageContext.request.contextPath}/admin/v2/fines/generate">生成逾期罚款</a></div>
    <section class="v2-card"><form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/fines">
        <div><label>状态</label><select class="v2-select" name="status"><option value="">全部</option><option value="UNPAID" ${status=='UNPAID'?'selected':''}>未缴费</option><option value="PAID" ${status=='PAID'?'selected':''}>已缴费</option></select></div>
        <div><label>关键词</label><input class="v2-input" name="keyword" value="${keyword}" placeholder="读者 / 图书"></div>
        <button class="v2-btn primary" type="submit">查询</button>
    </form></section>
    <section class="v2-card"><table class="v2-table">
        <tr><th>读者</th><th>图书</th><th>应还日期</th><th>金额</th><th>状态</th><th>生成时间</th><th>操作</th></tr>
        <c:forEach items="${list}" var="f"><tr>
            <td>${f.readerNo}<br>${f.readerName}</td><td>${f.bookName}</td><td>${fn:replace(f.dueDate, 'T', ' ')}</td><td>${f.amount}</td>
            <td><span class="v2-tag ${f.status=='PAID'?'ok':'danger'}">${f.status=='PAID'?'已缴费':'未缴费'}</span></td><td>${fn:replace(f.createTime, 'T', ' ')}</td>
            <td><c:if test="${f.status!='PAID'}"><a class="v2-btn ok" href="${pageContext.request.contextPath}/admin/v2/fines/pay/${f.id}/${f.borrowRecordId}" onclick="return confirm('确认已缴费？')">确认缴费</a></c:if></td>
        </tr></c:forEach>
        <c:if test="${empty list}"><tr><td colspan="7" class="v2-empty">暂无罚款记录</td></tr></c:if>
    </table></section>
</main></div></body></html>

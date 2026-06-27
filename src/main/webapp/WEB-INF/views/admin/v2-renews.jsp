<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>续借审核 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="renews"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>续借审核</h1><p>审核读者提交的续借申请。</p></div></div>
    <section class="v2-card">
        <form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/renews">
            <div><label>状态</label><select class="v2-select" name="status"><option value="">全部</option><option value="PENDING" ${status=='PENDING'?'selected':''}>待审核</option><option value="APPROVED" ${status=='APPROVED'?'selected':''}>已通过</option><option value="REJECTED" ${status=='REJECTED'?'selected':''}>已拒绝</option></select></div>
            <button class="v2-btn primary" type="submit">查询</button>
        </form>
    </section>
    <section class="v2-card"><table class="v2-table">
        <tr><th>读者</th><th>图书</th><th>原应还</th><th>理由</th><th>状态</th><th>申请时间</th><th>审核</th></tr>
        <c:forEach items="${list}" var="r"><tr>
            <td>${r.readerNo}<br>${r.readerName}</td><td>${r.bookName}</td><td>${fn:replace(r.dueDate, 'T', ' ')}</td><td>${r.reason}</td>
            <td><span class="v2-tag ${r.status=='PENDING'?'warn':(r.status=='APPROVED'?'ok':'danger')}">${r.status}</span></td>
            <td>${fn:replace(r.applyTime, 'T', ' ')}</td>
            <td class="v2-actions">
                <c:if test="${r.status=='PENDING'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/v2/renews/approve" style="display:inline-flex;gap:6px"><input type="hidden" name="id" value="${r.id}"><input type="hidden" name="borrowRecordId" value="${r.borrowRecordId}"><input class="v2-input" name="remark" placeholder="备注"><button class="v2-btn ok" type="submit">通过</button></form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/v2/renews/reject" style="display:inline-flex;gap:6px"><input type="hidden" name="id" value="${r.id}"><input class="v2-input" name="remark" placeholder="拒绝原因"><button class="v2-btn danger" type="submit">拒绝</button></form>
                </c:if>
                <c:if test="${r.status!='PENDING'}">${r.handlerName} ${r.remark}</c:if>
            </td>
        </tr></c:forEach>
        <c:if test="${empty list}"><tr><td colspan="7" class="v2-empty">暂无续借申请</td></tr></c:if>
    </table></section>
</main></div></body></html>

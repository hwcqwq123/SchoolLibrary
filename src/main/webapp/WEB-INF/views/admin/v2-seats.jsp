<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>座位预约管理 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="seats"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>座位预约管理</h1><p>查看和取消读者座位预约。</p></div></div>
    <section class="v2-card"><form class="v2-form" method="get" action="${pageContext.request.contextPath}/admin/v2/seats">
        <div><label>楼层</label><select class="v2-select" name="floorId"><option value="">全部楼层</option><c:forEach items="${floors}" var="f"><option value="${f.id}" ${floorId==f.id?'selected':''}>${f.floorName}</option></c:forEach></select></div>
        <div><label>日期</label><input class="v2-input" type="date" name="reservationDate" value="${reservationDate}"></div>
        <div><label>关键词</label><input class="v2-input" name="keyword" value="${keyword}" placeholder="读者 / 座位号"></div>
        <button class="v2-btn primary" type="submit">查询</button>
    </form></section>
    <section class="v2-card"><table class="v2-table">
        <tr><th>楼层</th><th>座位</th><th>读者</th><th>日期</th><th>时段</th><th>创建时间</th><th>操作</th></tr>
        <c:forEach items="${reservations}" var="r"><tr>
            <td>${r.floorName}</td><td>${r.seatNo}</td><td>${r.readerNo}<br>${r.readerName}</td><td>${fn:replace(r.reservationDate, 'T', ' ')}</td><td>${r.startTime}-${r.endTime}</td><td>${fn:replace(r.createTime, 'T', ' ')}</td>
            <td><a class="v2-btn danger" href="${pageContext.request.contextPath}/admin/v2/seats/cancel/${r.id}" onclick="return confirm('确认取消该预约？')">取消</a></td>
        </tr></c:forEach>
        <c:if test="${empty reservations}"><tr><td colspan="7" class="v2-empty">暂无预约记录</td></tr></c:if>
    </table></section>
</main></div></body></html>

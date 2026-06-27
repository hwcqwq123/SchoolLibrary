<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>座位预约 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="seats"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>座位预约</h1><p>10×10 座位可视化。灰色可选，绿色为我的预约，红色为他人已预约，黄色为临时锁定。</p></div></div>

    <div class="v2-alert warn">预约规则：每个读者在同一日期、同一时段只能预约一个座位；如需更换，请先取消原预约。</div>
    <c:if test="${seatMsg == 'one'}"><div class="v2-alert danger">该日期和时段你已经预约过一个座位，不能重复预约。</div></c:if>
    <c:if test="${seatMsg == 'occupied'}"><div class="v2-alert danger">该座位已被预约或临时锁定，请选择其他座位。</div></c:if>
    <c:if test="${seatMsg == 'success'}"><div class="v2-alert ok">预约成功。</div></c:if>

    <section class="v2-card">
        <form class="v2-form" method="get" action="${pageContext.request.contextPath}/reader/v2/seats">
            <div><label>楼层</label><select class="v2-select" name="floorId" required><option value="">请选择</option><c:forEach items="${floors}" var="f"><option value="${f.id}" ${floorId==f.id?'selected':''}>${f.floorName}</option></c:forEach></select></div>
            <div><label>日期</label><input class="v2-input" type="date" name="reservationDate" value="${reservationDate}" required></div>
            <div><label>时段</label><select class="v2-select" name="timeSlotId" required><option value="">请选择</option><c:forEach items="${slots}" var="s"><option value="${s.id}" ${timeSlotId==s.id?'selected':''}>${s.startTime}-${s.endTime}</option></c:forEach></select></div>
            <button class="v2-btn primary" type="submit">查看座位</button>
        </form>
    </section>

    <section class="v2-card">
        <h2>座位图</h2>
        <c:choose>
            <c:when test="${empty floorId || empty reservationDate || empty timeSlotId}"><div class="v2-empty">请选择楼层、日期和时段。</div></c:when>
            <c:otherwise>
                <div class="v2-seat-grid">
                    <c:forEach items="${seats}" var="s">
                        <c:choose>
                            <c:when test="${s.seatStatus == 'FREE'}">
                                <form method="post" action="${pageContext.request.contextPath}/reader/v2/seats/reserve">
                                    <input type="hidden" name="seatId" value="${s.id}">
                                    <input type="hidden" name="floorId" value="${floorId}">
                                    <input type="hidden" name="reservationDate" value="${reservationDate}">
                                    <input type="hidden" name="timeSlotId" value="${timeSlotId}">
                                    <button class="v2-seat free" type="submit" title="点击预约">${s.seatNo}</button>
                                </form>
                            </c:when>
                            <c:when test="${s.seatStatus == 'MINE' || s.seatStatus == 'LOCKED_MINE'}"><button class="v2-seat mine" disabled>${s.seatNo}</button></c:when>
                            <c:when test="${s.seatStatus == 'LOCKED'}"><button class="v2-seat locked" disabled>${s.seatNo}</button></c:when>
                            <c:otherwise><button class="v2-seat reserved" disabled>${s.seatNo}</button></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="v2-card">
        <h2>我的预约</h2>
        <table class="v2-table">
            <tr><th>楼层</th><th>座位</th><th>日期</th><th>时段</th><th>操作</th></tr>
            <c:forEach items="${myReservations}" var="r"><tr><td>${r.floorName}</td><td>${r.seatNo}</td><td>${fn:replace(r.reservationDate, 'T', ' ')}</td><td>${r.startTime}-${r.endTime}</td><td><a class="v2-btn danger" href="${pageContext.request.contextPath}/reader/v2/seats/cancel/${r.id}" onclick="return confirm('确认取消自己的预约？')">取消预约</a></td></tr></c:forEach>
            <c:if test="${empty myReservations}"><tr><td colspan="5" class="v2-empty">暂无预约</td></tr></c:if>
        </table>
    </section>
</main></div></body></html>

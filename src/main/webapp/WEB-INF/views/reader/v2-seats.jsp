<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>座位预约 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="seats"/></jsp:include>

    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>座位预约</h1>
                <p>10×10 座位可视化。灰色可选，绿色为我的预约，红色为他人已预约，黄色为临时锁定。</p>
            </div>
        </div>

        <div class="v2-alert warn">
            预约规则：每个读者在同一日期、同一时段只能预约一个座位；不能预约已经过去的日期或已经结束的时段。
        </div>
        <c:if test="${seatMsg == 'one'}"><div class="v2-alert danger">该日期和时段你已经预约过一个座位，不能重复预约。</div></c:if>
        <c:if test="${seatMsg == 'occupied'}"><div class="v2-alert danger">该座位已被预约或临时锁定，请选择其他座位。</div></c:if>
        <c:if test="${seatMsg == 'past'}"><div class="v2-alert danger">不能预约已经过去的日期或已经结束的时段，请重新选择。</div></c:if>
        <c:if test="${seatMsg == 'success'}"><div class="v2-alert ok">预约成功。</div></c:if>
        <c:if test="${pastSlot}"><div class="v2-alert danger">当前选择的日期和时段已经过去，座位按钮已禁用。</div></c:if>

        <section class="v2-card">
            <form id="seatSearchForm" class="v2-form" method="get" action="${pageContext.request.contextPath}/reader/v2/seats">
                <div>
                    <label>楼层</label>
                    <select class="v2-select" name="floorId" required>
                        <option value="">请选择</option>
                        <c:forEach items="${floors}" var="f">
                            <option value="${f.id}" ${floorId == f.id ? 'selected' : ''}>${f.floorName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label>日期</label>
                    <input id="reservationDate" class="v2-input" type="date" name="reservationDate" value="${reservationDate}" min="${today}" required>
                </div>
                <div>
                    <label>时段</label>
                    <select id="timeSlotId" class="v2-select" name="timeSlotId" required>
                        <option value="">请选择</option>
                        <c:forEach items="${slots}" var="s">
                            <option value="${s.id}" data-end="${s.endTime}" ${timeSlotId == s.id ? 'selected' : ''}>${s.startTime}-${s.endTime}</option>
                        </c:forEach>
                    </select>
                </div>
                <button id="seatSearchBtn" class="v2-btn primary" type="submit">查看座位</button>
            </form>
            <div id="seatPastHint" class="v2-alert danger" style="display:none;margin-top:14px;">该日期或时段已经过去，不能预约。</div>
        </section>

        <section class="v2-card">
            <h2>座位图</h2>
            <div class="v2-seat-legend">
                <span><i class="v2-seat-dot"></i> 可预约</span>
                <span><i class="v2-seat-dot mine"></i> 我的预约</span>
                <span><i class="v2-seat-dot reserved"></i> 他人预约</span>
                <span><i class="v2-seat-dot locked"></i> 临时锁定</span>
                <span><i class="v2-seat-dot past"></i> 已过时段</span>
            </div>

            <c:choose>
                <c:when test="${empty floorId || empty reservationDate || empty timeSlotId}">
                    <div class="v2-empty">请选择楼层、日期和时段。</div>
                </c:when>
                <c:otherwise>
                    <div class="v2-seat-grid">
                        <c:forEach items="${seats}" var="s">
                            <c:choose>
                                <c:when test="${pastSlot}">
                                    <button class="v2-seat past" type="button" disabled title="该时段已过去">${s.seatNo}</button>
                                </c:when>
                                <c:when test="${s.seatStatus == 'FREE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/reader/v2/seats/reserve">
                                        <input type="hidden" name="seatId" value="${s.id}">
                                        <input type="hidden" name="floorId" value="${floorId}">
                                        <input type="hidden" name="reservationDate" value="${reservationDate}">
                                        <input type="hidden" name="timeSlotId" value="${timeSlotId}">
                                        <button class="v2-seat free" type="submit" title="点击预约">${s.seatNo}</button>
                                    </form>
                                </c:when>
                                <c:when test="${s.seatStatus == 'MINE' || s.seatStatus == 'LOCKED_MINE'}">
                                    <button class="v2-seat mine" disabled>${s.seatNo}</button>
                                </c:when>
                                <c:when test="${s.seatStatus == 'LOCKED'}">
                                    <button class="v2-seat locked" disabled>${s.seatNo}</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="v2-seat reserved" disabled>${s.seatNo}</button>
                                </c:otherwise>
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
                <c:forEach items="${myReservations}" var="r">
                    <tr>
                        <td>${r.floorName}</td>
                        <td>${r.seatNo}</td>
                        <td>${fn:replace(r.reservationDate, 'T', ' ')}</td>
                        <td>${r.startTime}-${r.endTime}</td>
                        <td><a class="v2-btn danger" href="${pageContext.request.contextPath}/reader/v2/seats/cancel/${r.id}" onclick="return confirm('确认取消自己的预约？')">取消预约</a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty myReservations}"><tr><td colspan="5" class="v2-empty">暂无预约</td></tr></c:if>
            </table>
        </section>
    </main>
</div>

<script>
    // 【本次新增】前端提示：禁止选择过去日期或已经结束的时间段。
    (function () {
        var dateInput = document.getElementById('reservationDate');
        var slotSelect = document.getElementById('timeSlotId');
        var hint = document.getElementById('seatPastHint');
        var btn = document.getElementById('seatSearchBtn');

        function normalizeTime(t) {
            if (!t) return '00:00:00';
            return t.length === 5 ? t + ':00' : t;
        }

        function isPastSelection() {
            if (!dateInput || !slotSelect || !dateInput.value || !slotSelect.value) {
                return false;
            }
            var option = slotSelect.options[slotSelect.selectedIndex];
            var endTime = normalizeTime(option.getAttribute('data-end'));
            var selectedEnd = new Date(dateInput.value + 'T' + endTime);
            return selectedEnd.getTime() <= Date.now();
        }

        function refreshState() {
            var past = isPastSelection();
            if (hint) hint.style.display = past ? 'block' : 'none';
            if (btn) {
                btn.disabled = past;
                btn.classList.toggle('disabled', past);
            }
        }

        if (dateInput) dateInput.addEventListener('change', refreshState);
        if (slotSelect) slotSelect.addEventListener('change', refreshState);
        refreshState();
    })();
</script>
</body>
</html>

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
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="v2-top">
            <div>
                <h1>座位预约</h1>
                <p>10×10 座位可视化。灰色可选，绿色为我的预约，红色为他人已预约，黄色为临时锁定。</p>
            </div>
        </div>

        <%-- 【本次修改】恢复座位预约提示和蓝色系卡片样式。 --%>
        <section class="v2-card v2-seat-panel">
            <div class="v2-alert">
                每个读者在同一日期、同一时间段只能预约一个座位；不能预约过去日期或今天已经结束的时间段。
            </div>

           <form class="v2-form v2-seat-search-form" method="get" action="${pageContext.request.contextPath}/reader/v2/seats">
    <div>
        <label>楼层</label>
        <select class="v2-select" name="floorId" required>
            <option value="">请选择楼层</option>
            <c:forEach items="${floors}" var="f">
                <option value="${f.id}" ${floorId == f.id ? 'selected' : ''}>${f.floorName}</option>
            </c:forEach>
        </select>
    </div>

    <div>
        <label>日期</label>
        <input class="v2-input" type="date" name="reservationDate"
               value="${reservationDate}" min="${today}" required>
    </div>

    <div>
        <label>时段</label>
        <select class="v2-select" name="timeSlotId" required>
            <option value="">请选择时段</option>
            <c:forEach items="${slots}" var="s">
                <option value="${s.id}" ${timeSlotId == s.id ? 'selected' : ''}>
                    ${s.startTime}-${s.endTime}
                </option>
            </c:forEach>
        </select>
    </div>

    <%-- 【本次修改】查询按钮放到时段右侧，按钮缩小，文字放大。 --%>
    <div class="v2-seat-query-action">
        <button class="v2-btn primary v2-seat-query-btn" type="submit">查看座位</button>
    </div>
</form>
        </section>

        <c:if test="${pastSlot}">
            <div class="v2-alert danger">
                当前选择的日期或时段已经过去，不能预约。请重新选择未来时段。
            </div>
        </c:if>

        <section class="v2-card">
            <div class="v2-seat-toolbar">
                <div>
                    <h2>座位图</h2>
                    <div class="v2-seat-note">
                        已选楼层：${empty floorId ? '未选择' : floorId}　
                        日期：${empty reservationDate ? '未选择' : reservationDate}　
                        时段：${empty timeSlotId ? '未选择' : timeSlotId}
                    </div>
                </div>
            </div>

            <div class="v2-seat-legend">
                <span><i class="v2-seat-dot free"></i>可预约</span>
                <span><i class="v2-seat-dot mine"></i>我的预约</span>
                <span><i class="v2-seat-dot reserved"></i>他人已约</span>
                <span><i class="v2-seat-dot locked"></i>临时锁定</span>
                <span><i class="v2-seat-dot past"></i>过去时段不可约</span>
            </div>

            <c:choose>
                <c:when test="${empty floorId or empty reservationDate or empty timeSlotId}">
                    <div class="v2-empty">请选择楼层、日期和时段后查看座位。</div>
                </c:when>
                <c:otherwise>
                    <div class="v2-seat-grid">
                        <c:forEach items="${seats}" var="s">
                            <c:set var="seatClass" value="free"/>
                            <c:if test="${s.seatStatus == 'MINE'}"><c:set var="seatClass" value="mine"/></c:if>
                            <c:if test="${s.seatStatus == 'LOCKED_MINE'}"><c:set var="seatClass" value="locked-mine"/></c:if>
                            <c:if test="${s.seatStatus == 'RESERVED'}"><c:set var="seatClass" value="reserved"/></c:if>
                            <c:if test="${s.seatStatus == 'LOCKED'}"><c:set var="seatClass" value="locked"/></c:if>
                            <c:if test="${pastSlot}"><c:set var="seatClass" value="past"/></c:if>

                            <form class="v2-seat-form" method="post" action="${pageContext.request.contextPath}/reader/v2/seats/reserve">
                                <input type="hidden" name="seatId" value="${s.id}">
                                <input type="hidden" name="floorId" value="${floorId}">
                                <input type="hidden" name="reservationDate" value="${reservationDate}">
                                <input type="hidden" name="timeSlotId" value="${timeSlotId}">

                                <button class="v2-seat ${seatClass}"
                                        type="submit"
                                        title="${s.seatNo}"
                                        <c:if test="${pastSlot or s.seatStatus != 'FREE'}">disabled</c:if>>
                                    ${s.seatNo}
                                </button>
                            </form>
                        </c:forEach>
                    </div>
                    <div class="v2-seat-note">点击灰色座位即可提交预约。后端会再次校验是否重复预约、是否已被他人预约、是否为过去时段。</div>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="v2-card">
            <h2>我的预约</h2>
            <table class="v2-table">
                <thead>
                <tr>
                    <th>楼层</th>
                    <th>座位</th>
                    <th>日期</th>
                    <th>时段</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${myReservations}" var="r">
                    <tr>
                        <td>${r.floorName}</td>
                        <td>${r.seatNo}</td>
                        <td>${r.reservationDate}</td>
                        <td>${r.startTime}-${r.endTime}</td>
                        <td>
                            <a class="v2-btn danger"
                               href="${pageContext.request.contextPath}/reader/v2/seats/cancel/${r.id}"
                               onclick="return confirm('确认取消自己的预约？')">取消预约</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty myReservations}">
                    <tr><td colspan="5" class="v2-empty">暂无有效预约</td></tr>
                </c:if>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>

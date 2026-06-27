<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页看板 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">

   
        <section class="v2-dashboard-hero">
            <div>
                <h1>图书馆数据一览</h1>
                <p>集中查看馆藏规模、读者数量、借阅状态、逾期提醒和座位使用情况。</p>
            </div>
            <div class="v2-hero-panel">
                <strong>${empty stats.borrowedTotal ? 0 : stats.borrowedTotal}</strong>
                <span>当前借出图书数量</span>
                <div class="v2-hero-line"><i></i></div>
                <span>逾期未还：${empty stats.overdueTotal ? 0 : stats.overdueTotal} 本</span>
            </div>
        </section>

        <section class="v2-dashboard-grid">
            <div class="v2-kpi-card">
                <span>图书总数</span>
                <strong>${empty stats.bookTotal ? 0 : stats.bookTotal}</strong>
                <em>馆藏资源规模</em>
                <div class="v2-kpi-bar"><i style="width: 88%;"></i></div>
            </div>
            <div class="v2-kpi-card">
                <span>读者总数</span>
                <strong>${empty stats.readerTotal ? 0 : stats.readerTotal}</strong>
                <em>有效读者账户</em>
                <div class="v2-kpi-bar"><i style="width: 72%;"></i></div>
            </div>
            <div class="v2-kpi-card">
                <span>当前借出</span>
                <strong>${empty stats.borrowedTotal ? 0 : stats.borrowedTotal}</strong>
                <em>正在流通图书</em>
                <div class="v2-kpi-bar"><i style="width: 62%;"></i></div>
            </div>
            <div class="v2-kpi-card">
                <span>逾期未还</span>
                <strong>${empty stats.overdueTotal ? 0 : stats.overdueTotal}</strong>
                <em>需重点关注</em>
                <div class="v2-kpi-bar"><i style="width: 34%;"></i></div>
            </div>
            <div class="v2-kpi-card">
                <span>今日借阅</span>
                <strong>${empty stats.todayBorrowTotal ? 0 : stats.todayBorrowTotal}</strong>
                <em>今日新增借出</em>
                <div class="v2-kpi-bar"><i style="width: 48%;"></i></div>
            </div>
            <div class="v2-kpi-card">
                <span>今日座位预约</span>
                <strong>${empty stats.todaySeatTotal ? 0 : stats.todaySeatTotal}</strong>
                <em>阅览座位使用</em>
                <div class="v2-kpi-bar"><i style="width: 56%;"></i></div>
            </div>
        </section>

        <div class="v2-dashboard-row">
            <section class="v2-card v2-visual-card">
                <h2>分类馆藏可视化</h2>
                <div class="v2-mini-bars">
                    <c:forEach items="${categoryStats}" var="c">
                        <div class="v2-mini-bar-row">
                            <div class="v2-mini-bar-name">${c.categoryName}</div>
                            <div class="v2-mini-bar-track">
                                <i style="width:${c.bookCount * 8 + 12}%; max-width:100%;"></i>
                            </div>
                            <div class="v2-mini-bar-value">${c.bookCount}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty categoryStats}">
                        <div class="v2-empty">暂无分类统计数据</div>
                    </c:if>
                </div>
            </section>

            <section class="v2-card">
                <h2>最新公告</h2>
                <table class="v2-table">
                    <thead>
                    <tr>
                        <th>标题</th>
                        <th>发布时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${latestNotices}" var="n">
                        <tr>
                            <td>${n.title}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty n.createTime}">
                                        ${fn:replace(n.createTime, 'T', ' ')}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty latestNotices}">
                        <tr><td colspan="2" class="v2-empty">暂无公告</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </section>
        </div>

        <div class="v2-dashboard-row">
            <section class="v2-card">
                <h2>最近借阅</h2>
                <table class="v2-table">
                    <thead>
                    <tr>
                        <th>读者</th>
                        <th>图书</th>
                        <th>借出时间</th>
                        <th>应还时间</th>
                        <th>状态</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${recentBorrows}" var="b">
                        <tr>
                            <td>${b.readerName}</td>
                            <td>${b.bookName}</td>
                            <td>${fn:replace(b.borrowDate, 'T', ' ')}</td>
                            <td>${fn:replace(b.dueDate, 'T', ' ')}</td>
                            <td><span class="v2-tag">${b.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentBorrows}">
                        <tr><td colspan="5" class="v2-empty">暂无借阅记录</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </section>

            <section class="v2-card">
                <h2>逾期提醒</h2>
                <table class="v2-table">
                    <thead>
                    <tr>
                        <th>读者</th>
                        <th>图书</th>
                        <th>应还日期</th>
                        <th>逾期天数</th>
                        <th>预计罚款</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${overdueList}" var="o">
                        <tr>
                            <td>${o.readerName}</td>
                            <td>${o.bookName}</td>
                            <td>${fn:replace(o.dueDate, 'T', ' ')}</td>
                            <td><span class="v2-tag danger">${o.overdueDays}</span></td>
                            <td>${o.fine}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty overdueList}">
                        <tr><td colspan="5" class="v2-empty">暂无逾期记录</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </section>
        </div>
    </main>
</div>
</body>
</html>

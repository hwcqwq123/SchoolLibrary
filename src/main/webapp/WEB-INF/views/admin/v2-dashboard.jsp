<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页统计 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="dashboard"/></jsp:include>

    <main class="v2-main">
        <%-- 【本次修改】首页统计增加蓝色可视化版面，避免数据区过于单薄。 --%>
        <section class="v2-dashboard-hero">
            <div>
                <h1>今日图书馆看板</h1>
                <p>集中展示馆藏、读者、借阅、逾期、座位预约与公告信息，帮助管理员快速掌握图书馆运行状态。</p>
                <div class="v2-hero-chips">
                    <span class="v2-hero-chip">实时统计</span>
                    <span class="v2-hero-chip">逾期提醒</span>
                    <span class="v2-hero-chip">座位概览</span>
                </div>
            </div>
            <div class="v2-hero-panel">
                <strong>${stats.bookTotal}</strong>
                <span>当前馆藏图书总量</span>
                <div class="v2-hero-line"><i></i></div>
                <p>当前借出 ${stats.borrowedTotal} 本，逾期未还 ${stats.overdueTotal} 本。</p>
            </div>
        </section>

        <section class="v2-stat-grid">
            <div class="v2-stat-card">
                <span>图书总数</span>
                <strong>${stats.bookTotal}</strong>
                <div class="v2-stat-meta">馆藏资源规模</div>
                <div class="v2-stat-bar"><i class="v2-w-85"></i></div>
            </div>
            <div class="v2-stat-card">
                <span>读者总数</span>
                <strong>${stats.readerTotal}</strong>
                <div class="v2-stat-meta">已启用读者账户</div>
                <div class="v2-stat-bar"><i class="v2-w-65"></i></div>
            </div>
            <div class="v2-stat-card">
                <span>当前借出</span>
                <strong>${stats.borrowedTotal}</strong>
                <div class="v2-stat-meta">仍在借阅中的图书</div>
                <div class="v2-stat-bar"><i class="v2-w-55"></i></div>
            </div>
            <div class="v2-stat-card">
                <span>逾期未还</span>
                <strong>${stats.overdueTotal}</strong>
                <div class="v2-stat-meta">需要跟进提醒</div>
                <div class="v2-stat-bar"><i class="v2-w-35"></i></div>
            </div>
            <div class="v2-stat-card">
                <span>今日借阅</span>
                <strong>${stats.todayBorrowTotal}</strong>
                <div class="v2-stat-meta">今日新增借阅量</div>
                <div class="v2-stat-bar"><i class="v2-w-45"></i></div>
            </div>
            <div class="v2-stat-card">
                <span>今日座位预约</span>
                <strong>${stats.todaySeatTotal}</strong>
                <div class="v2-stat-meta">今日有效座位预约</div>
                <div class="v2-stat-bar"><i class="v2-w-75"></i></div>
            </div>
        </section>

        <div class="v2-two-col">
            <section class="v2-card v2-visual-card">
                <h2>分类馆藏统计</h2>
                <div class="v2-mini-bars">
                    <c:forEach items="${categoryStats}" var="c">
                        <div class="v2-mini-bar-row">
                            <div class="v2-mini-bar-name">${c.categoryName}</div>
                            <div class="v2-mini-bar-track"><i style="width:${c.bookCount == 0 ? 8 : (c.bookCount * 18 + 18)}%;"></i></div>
                            <div class="v2-mini-bar-value">${c.bookCount} 本</div>
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
                    <tr><th>标题</th><th>时间</th></tr>
                    <c:forEach items="${latestNotices}" var="n">
                        <tr><td>${n.title}</td><td>${fn:replace(n.createTime, 'T', ' ')}</td></tr>
                    </c:forEach>
                    <c:if test="${empty latestNotices}"><tr><td colspan="2" class="v2-empty">暂无公告</td></tr></c:if>
                </table>
            </section>
        </div>

        <section class="v2-card">
            <h2>最近借阅</h2>
            <table class="v2-table">
                <tr><th>读者</th><th>图书</th><th>借出时间</th><th>应还时间</th><th>状态</th></tr>
                <c:forEach items="${recentBorrows}" var="b">
                    <tr>
                        <td>${b.readerName}</td>
                        <td>${b.bookName}</td>
                        <td>${fn:replace(b.borrowDate, 'T', ' ')}</td>
                        <td>${fn:replace(b.dueDate, 'T', ' ')}</td>
                        <td><span class="v2-tag ${b.status == 'BORROWED' ? 'info' : 'ok'}">${b.status}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentBorrows}"><tr><td colspan="5" class="v2-empty">暂无借阅记录</td></tr></c:if>
            </table>
        </section>

        <section class="v2-card">
            <h2>逾期提醒</h2>
            <table class="v2-table">
                <tr><th>读者</th><th>图书</th><th>应还日期</th><th>逾期天数</th><th>预计罚款</th></tr>
                <c:forEach items="${overdueList}" var="o">
                    <tr>
                        <td>${o.readerName}</td>
                        <td>${o.bookName}</td>
                        <td>${fn:replace(o.dueDate, 'T', ' ')}</td>
                        <td><span class="v2-tag danger">${o.overdueDays} 天</span></td>
                        <td>${o.fine}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty overdueList}"><tr><td colspan="5" class="v2-empty">暂无逾期记录</td></tr></c:if>
            </table>
        </section>
    </main>
</div>
</body>
</html>

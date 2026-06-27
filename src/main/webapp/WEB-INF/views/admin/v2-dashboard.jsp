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
        <div class="v2-page-head">
            <div>
                <h1>今日图书馆看板</h1>
                <p>馆藏、借阅、逾期、座位预约与公告概览。</p>
            </div>
        </div>

        <section class="v2-stat-grid">
            <div class="v2-stat-card"><span>图书总数</span><strong>${stats.bookTotal}</strong></div>
            <div class="v2-stat-card"><span>读者总数</span><strong>${stats.readerTotal}</strong></div>
            <div class="v2-stat-card"><span>当前借出</span><strong>${stats.borrowedTotal}</strong></div>
            <div class="v2-stat-card"><span>逾期未还</span><strong>${stats.overdueTotal}</strong></div>
            <div class="v2-stat-card"><span>今日借阅</span><strong>${stats.todayBorrowTotal}</strong></div>
            <div class="v2-stat-card"><span>今日座位预约</span><strong>${stats.todaySeatTotal}</strong></div>
        </section>

        <div class="v2-two-col">
            <section class="v2-card">
                <h2>分类馆藏统计</h2>
                <table class="v2-table">
                    <tr><th>分类</th><th>图书数量</th></tr>
                    <c:forEach items="${categoryStats}" var="c">
                        <tr><td>${c.categoryName}</td><td>${c.bookCount}</td></tr>
                    </c:forEach>
                    <c:if test="${empty categoryStats}"><tr><td colspan="2" class="v2-empty">暂无分类统计数据</td></tr></c:if>
                </table>
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
                        <td>${b.status}</td>
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
                        <td>${o.overdueDays}</td>
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

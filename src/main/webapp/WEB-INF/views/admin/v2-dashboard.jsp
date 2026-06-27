<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>管理员首页</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout"><jsp:include page="v2-sidebar.jsp"/><main class="v2-main">
<div class="v2-top"><div><h1>今日图书馆看板</h1><p>馆藏、借阅、逾期、座位预约与公告概览。</p></div><a class="v2-btn" href="${pageContext.request.contextPath}/logout">退出</a></div>
<div class="v2-grid">
<div class="v2-stat"><strong>${stats.bookTotal}</strong><span>图书总数</span></div>
<div class="v2-stat"><strong>${stats.readerTotal}</strong><span>读者总数</span></div>
<div class="v2-stat"><strong>${stats.borrowedTotal}</strong><span>当前借出</span></div>
<div class="v2-stat"><strong>${stats.overdueTotal}</strong><span>逾期未还</span></div>
<div class="v2-stat"><strong>${stats.todayBorrowTotal}</strong><span>今日借阅</span></div>
<div class="v2-stat"><strong>${stats.todaySeatTotal}</strong><span>今日座位预约</span></div>
</div>
<div class="v2-grid-2">
<section class="v2-card"><h2>分类馆藏统计</h2><table class="v2-table"><tr><th>分类</th><th>图书数量</th></tr><c:forEach items="${categoryStats}" var="c"><tr><td>${c.categoryName}</td><td>${c.bookCount}</td></tr></c:forEach></table></section>
<section class="v2-card"><h2>最新公告</h2><table class="v2-table"><tr><th>标题</th><th>时间</th></tr><c:forEach items="${latestNotices}" var="n"><tr><td>${n.title}</td><td><fmt:formatDate value="${n.createTime}" pattern="yyyy-MM-dd"/></td></tr></c:forEach></table></section>
</div>
<section class="v2-card"><h2>最近借阅</h2><table class="v2-table"><tr><th>读者</th><th>图书</th><th>借出</th><th>应还</th><th>状态</th></tr><c:forEach items="${recentBorrows}" var="b"><tr><td>${b.readerName}</td><td>${b.bookName}</td><td><fmt:formatDate value="${b.borrowDate}" pattern="yyyy-MM-dd"/></td><td><fmt:formatDate value="${b.dueDate}" pattern="yyyy-MM-dd"/></td><td>${b.status}</td></tr></c:forEach></table></section>
<section class="v2-card"><h2>逾期提醒</h2><table class="v2-table"><tr><th>读者</th><th>图书</th><th>应还日期</th><th>逾期天数</th><th>罚款</th></tr><c:forEach items="${overdueList}" var="o"><tr><td>${o.readerName}</td><td>${o.bookName}</td><td><fmt:formatDate value="${o.dueDate}" pattern="yyyy-MM-dd"/></td><td>${o.overdueDays}</td><td>${o.fine}</td></tr></c:forEach></table></section>
</main></div></body></html>

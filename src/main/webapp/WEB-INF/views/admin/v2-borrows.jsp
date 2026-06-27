<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>借阅概览 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="borrows"/></jsp:include>
    <main class="v2-main">
        <div class="v2-page-head">
            <div>
                <h1>借阅概览</h1>
                <p>查看最近借阅、归还状态与逾期提醒。</p>
            </div>
            <span class="v2-tag info">旧入口 /admin/borrows 已兼容到这里</span>
        </div>

        <section class="v2-card">
            <h2>最近借阅</h2>
            <table class="v2-table">
                <tr><th>读者</th><th>图书</th><th>借出时间</th><th>应还时间</th><th>归还时间</th><th>状态</th></tr>
                <c:forEach items="${recentBorrows}" var="b">
                    <tr>
                        <td>${b.readerName}</td>
                        <td>${b.bookName}</td>
                        <td>${fn:replace(b.borrowDate, 'T', ' ')}</td>
                        <td>${fn:replace(b.dueDate, 'T', ' ')}</td>
                        <td>${fn:replace(b.returnDate, 'T', ' ')}</td>
                        <td>${b.status}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentBorrows}"><tr><td colspan="6" class="v2-empty">暂无借阅记录</td></tr></c:if>
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

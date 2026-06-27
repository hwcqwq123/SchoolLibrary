<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员首页 - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
</head>
<body>

<div class="v2-layout">

    <aside class="v2-sidebar">
        <div class="v2-logo">图书馆管理系统</div>

        <%-- 【本次修改】统一使用 v2 路径，避免跳回旧页面 --%>
        <a href="${pageContext.request.contextPath}/admin/v2/dashboard" class="active">首页看板</a>
        <a href="${pageContext.request.contextPath}/admin/v2/books">图书管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/categories">分类管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/readers">读者管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/borrows">借阅管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/renews">续借审核</a>
        <a href="${pageContext.request.contextPath}/admin/v2/fines">罚款管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/seats">座位预约</a>
        <a href="${pageContext.request.contextPath}/admin/v2/notices">公告管理</a>
        <a href="${pageContext.request.contextPath}/admin/v2/data">数据维护</a>
        <a href="${pageContext.request.contextPath}/admin/v2/system">系统管理</a>
        <a href="${pageContext.request.contextPath}/logout">退出登录</a>
    </aside>

    <main class="v2-main">

        <div class="v2-page-header">
            <div>
                <h1>今日图书馆看板</h1>
                <p>馆藏、借阅、逾期、座位预约与公告概览。</p>
            </div>
        </div>

        <section class="v2-stat-grid">
            <div class="v2-stat-card">
                <span>图书总数</span>
                <strong>${stats.bookTotal}</strong>
            </div>

            <div class="v2-stat-card">
                <span>读者总数</span>
                <strong>${stats.readerTotal}</strong>
            </div>

            <div class="v2-stat-card">
                <span>当前借出</span>
                <strong>${stats.borrowedTotal}</strong>
            </div>

            <div class="v2-stat-card">
                <span>逾期未还</span>
                <strong>${stats.overdueTotal}</strong>
            </div>

            <div class="v2-stat-card">
                <span>今日借阅</span>
                <strong>${stats.todayBorrowTotal}</strong>
            </div>

            <div class="v2-stat-card">
                <span>今日座位预约</span>
                <strong>${stats.todaySeatTotal}</strong>
            </div>
        </section>

        <div class="v2-two-column">

            <section class="v2-card">
                <h2>分类馆藏统计</h2>

                <table class="v2-table">
                    <thead>
                    <tr>
                        <th>分类</th>
                        <th>图书数量</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${categoryStats}" var="c">
                        <tr>
                            <td>${c.categoryName}</td>
                            <td>${c.bookCount}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty categoryStats}">
                        <tr>
                            <td colspan="2">暂无分类统计数据</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </section>

            <section class="v2-card">
                <h2>最新公告</h2>

                <table class="v2-table">
                    <thead>
                    <tr>
                        <th>标题</th>
                        <th>时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${latestNotices}" var="n">
                        <tr>
                            <td>${n.title}</td>

                            <%--
                                【本次修改】
                                不再使用 fmt:formatDate。
                                原因：createTime 可能是 java.time.LocalDateTime，
                                fmt:formatDate 无法直接处理 LocalDateTime。
                            --%>
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
                        <tr>
                            <td colspan="2">暂无公告</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </section>

        </div>

        <section class="v2-card">
            <h2>最近借阅</h2>

            <table class="v2-table">
                <thead>
                <tr>
                    <th>读者</th>
                    <th>图书</th>
                    <th>借出</th>
                    <th>应还</th>
                    <th>状态</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${recentBorrows}" var="b">
                    <tr>
                        <td>${b.readerName}</td>
                        <td>${b.bookName}</td>

                        <%--
                            【本次修改】
                            borrowDate / dueDate 可能是 LocalDateTime。
                            这里直接转字符串并把 T 替换为空格，避免 JSP 500。
                        --%>
                        <td>
                            <c:choose>
                                <c:when test="${not empty b.borrowDate}">
                                    ${fn:replace(b.borrowDate, 'T', ' ')}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty b.dueDate}">
                                    ${fn:replace(b.dueDate, 'T', ' ')}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>${b.status}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty recentBorrows}">
                    <tr>
                        <td colspan="5">暂无借阅记录</td>
                    </tr>
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
                    <th>罚款</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${overdueList}" var="o">
                    <tr>
                        <td>${o.readerName}</td>
                        <td>${o.bookName}</td>

                        <%-- 【本次修改】不再使用 fmt:formatDate，避免 LocalDateTime 转 Date 报错 --%>
                        <td>
                            <c:choose>
                                <c:when test="${not empty o.dueDate}">
                                    ${fn:replace(o.dueDate, 'T', ' ')}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>${o.overdueDays}</td>
                        <td>${o.fine}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty overdueList}">
                    <tr>
                        <td colspan="5">暂无逾期记录</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </section>

    </main>
</div>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>借阅管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2-business.css">
</head>
<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="v2-top">
            <div>
                <h1>借阅管理</h1>
                <p>普通管理员办理借书、还书和上架确认。读者端只负责查询图书状态，不直接借书。</p>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="v2-alert ok">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="v2-alert danger">${param.error}</div>
        </c:if>
        <c:if test="${autoShelfCount gt 0}">
            <div class="v2-alert ok">系统已自动上架 ${autoShelfCount} 本超过 2 天上架期的图书。</div>
        </c:if>

        <section class="v2-borrow-hero">
            <div>
                <h2>实体书编码借阅流程</h2>
                <p>借书时输入读者编号和图书实体编码；还书后图书先进入“上架中”，两天后自动恢复为“已上架”，也可以由管理员手动确认上架。</p>
                <div class="v2-flow">
                    <span>已上架</span><i>→</i><span>借出中</span><i>→</i><span>上架中</span><i>→</i><span>已上架</span>
                </div>
            </div>
            <div class="v2-borrow-hero-card">
                <strong>${fn:length(processingCopies)}</strong>
                <span>当前上架中图书</span>
            </div>
        </section>

        <section class="v2-borrow-actions">
            <div class="v2-card v2-business-card">
                <h2>办理借书</h2>
                <p class="v2-muted">普通管理员输入读者编号/学号和实体书编码后办理借出。</p>
                <form class="v2-form one" method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/borrow">
                    <div>
                        <label>读者编号 / 学号 / 用户名 / 姓名</label>
                        <input class="v2-input" name="readerKey" placeholder="例如：R2026001 或 202401001" required>
                    </div>
                    <div>
                        <label>图书实体编码</label>
                        <input class="v2-input" name="copyNo" placeholder="例如：B2026001-001" required>
                    </div>
                    <div>
                        <label>借阅天数</label>
                        <input class="v2-input" type="number" name="borrowDays" value="30" min="1" max="180">
                    </div>
                    <button class="v2-btn primary v2-wide-btn" type="submit">确认借出</button>
                </form>
            </div>

            <div class="v2-card v2-business-card">
                <h2>办理还书</h2>
                <p class="v2-muted">输入归还图书的实体编码。归还后不会立即回到书架，而是进入“上架中”。</p>
                <form class="v2-form one" method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/return">
                    <div>
                        <label>图书实体编码</label>
                        <input class="v2-input" name="copyNo" placeholder="例如：B2026001-001" required>
                    </div>
                    <button class="v2-btn warn v2-wide-btn" type="submit">确认归还并进入上架中</button>
                </form>
                <div class="v2-business-note">逾期归还时系统会自动生成罚款记录。</div>
            </div>
        </section>

        <section class="v2-card">
            <h2>上架处理中</h2>
            <p class="v2-muted">已归还但尚未回到书架的图书。达到预计上架时间后，访问本页面会自动上架；管理员也可以手动确认。</p>
            <table class="v2-table">
                <thead>
                <tr>
                    <th>实体编码</th>
                    <th>书名</th>
                    <th>归还处理开始</th>
                    <th>预计自动上架</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${processingCopies}" var="c">
                    <tr>
                        <td><strong>${c.copyNo}</strong></td>
                        <td>${c.bookName}</td>
                        <td>${fn:replace(c.returnProcessStartTime, 'T', ' ')}</td>
                        <td>${fn:replace(c.availableAt, 'T', ' ')}</td>
                        <td><span class="v2-tag warn">上架中</span></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/shelf/${c.id}" onsubmit="return confirm('确认将该书改为已上架？')">
                                <button class="v2-btn ok" type="submit">确认上架</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty processingCopies}">
                    <tr><td colspan="6" class="v2-empty">暂无上架中的图书</td></tr>
                </c:if>
                </tbody>
            </table>
        </section>

        <section class="v2-card">
            <h2>最近借阅记录</h2>
            <table class="v2-table">
                <thead>
                <tr>
                    <th>读者</th>
                    <th>图书</th>
                    <th>实体编码</th>
                    <th>借出时间</th>
                    <th>应还时间</th>
                    <th>归还时间</th>
                    <th>状态</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${recentBorrows}" var="b">
                    <tr>
                        <td>${b.readerName}</td>
                        <td>${b.bookName}</td>
                        <td>${empty b.copyNo ? '-' : b.copyNo}</td>
                        <td>${fn:replace(b.borrowDate, 'T', ' ')}</td>
                        <td>${fn:replace(b.dueDate, 'T', ' ')}</td>
                        <td>${fn:replace(b.returnDate, 'T', ' ')}</td>
                        <td>
                            <c:choose>
                                <c:when test="${b.status == 'BORROWED'}"><span class="v2-tag warn">借出中</span></c:when>
                                <c:when test="${b.status == 'RETURNED'}"><span class="v2-tag ok">已归还</span></c:when>
                                <c:when test="${b.status == 'OVERDUE_RETURNED'}"><span class="v2-tag danger">逾期已归还</span></c:when>
                                <c:otherwise><span class="v2-tag">${b.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentBorrows}">
                    <tr><td colspan="7" class="v2-empty">暂无借阅记录</td></tr>
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
                    <th>实体编码</th>
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
                        <td>${empty o.copyNo ? '-' : o.copyNo}</td>
                        <td>${fn:replace(o.dueDate, 'T', ' ')}</td>
                        <td>${o.overdueDays}</td>
                        <td>${o.fine}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty overdueList}">
                    <tr><td colspan="6" class="v2-empty">暂无逾期记录</td></tr>
                </c:if>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>

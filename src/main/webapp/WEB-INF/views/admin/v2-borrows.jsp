<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>借阅管理 - 图书馆管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">

    <%-- 【本次修改】借阅管理页面专属高级 UI。放在本 JSP 内，避免覆盖全局 v2.css 造成其他页面变形。 --%>
    <style>
        .borrow-shell {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .borrow-head {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 4px;
        }

        .borrow-head h1 {
            margin: 0 0 8px;
            font-size: 30px;
            font-weight: 900;
            color: #0f172a;
            letter-spacing: -0.6px;
        }

        .borrow-head p {
            margin: 0;
            color: #64748b;
            font-size: 15px;
            line-height: 1.7;
        }

        .borrow-head-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .borrow-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid #dbeafe;
            color: #1e3a8a;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 10px 22px rgba(37, 99, 235, .08);
        }

        .borrow-pill-dot {
            width: 8px;
            height: 8px;
            border-radius: 99px;
            background: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .borrow-alert {
            padding: 14px 16px;
            border-radius: 16px;
            font-size: 14px;
            font-weight: 800;
            line-height: 1.6;
        }

        .borrow-alert.success {
            background: #ecfdf5;
            color: #166534;
            border: 1px solid #86efac;
        }

        .borrow-alert.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .borrow-hero {
            position: relative;
            overflow: hidden;
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) 430px;
            gap: 26px;
            padding: 30px;
            border-radius: 28px;
            background:
                    radial-gradient(circle at 84% 15%, rgba(96, 165, 250, .38), transparent 30%),
                    radial-gradient(circle at 15% 95%, rgba(14, 165, 233, .22), transparent 28%),
                    linear-gradient(135deg, #0f172a 0%, #1e3a8a 44%, #2563eb 100%);
            color: #fff;
            box-shadow: 0 24px 48px rgba(30, 58, 138, .22);
        }

        .borrow-hero:before {
            content: "";
            position: absolute;
            inset: -80px -80px auto auto;
            width: 260px;
            height: 260px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .11);
            filter: blur(1px);
        }

        .borrow-hero-main {
            position: relative;
            z-index: 1;
        }

        .borrow-hero-main h2 {
            margin: 0 0 12px;
            font-size: 24px;
            font-weight: 900;
            letter-spacing: -0.3px;
        }

        .borrow-hero-main p {
            max-width: 900px;
            margin: 0;
            color: rgba(255, 255, 255, .88);
            font-size: 14px;
            line-height: 1.9;
        }

        .borrow-flow {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }

        .borrow-flow span {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .13);
            border: 1px solid rgba(255, 255, 255, .24);
            color: #fff;
            font-size: 13px;
            font-weight: 900;
            backdrop-filter: blur(8px);
        }

        .borrow-flow i {
            color: rgba(255, 255, 255, .75);
            font-style: normal;
            font-weight: 900;
        }

        .borrow-stats {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }

        .borrow-stat {
            padding: 18px;
            border-radius: 22px;
            background: rgba(15, 23, 42, .26);
            border: 1px solid rgba(255, 255, 255, .20);
            backdrop-filter: blur(12px);
        }

        .borrow-stat strong {
            display: block;
            margin-bottom: 8px;
            font-size: 30px;
            line-height: 1;
            font-weight: 950;
            color: #fff;
        }

        .borrow-stat span {
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
            font-weight: 800;
        }

        .borrow-workbench {
            display: grid;
            grid-template-columns: minmax(0, 1.08fr) minmax(360px, .92fr);
            gap: 18px;
        }

        .borrow-card {
            background: #fff;
            border: 1px solid #dbeafe;
            border-radius: 24px;
            box-shadow: 0 18px 38px rgba(15, 23, 42, .06);
        }

        .borrow-card-inner {
            padding: 24px;
        }

        .borrow-card-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 18px;
        }

        .borrow-card-head h2 {
            margin: 0 0 7px;
            font-size: 21px;
            font-weight: 900;
            color: #0f172a;
        }

        .borrow-card-head p {
            margin: 0;
            color: #64748b;
            line-height: 1.7;
            font-size: 13px;
        }

        .borrow-badge {
            flex: 0 0 auto;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: .3px;
        }

        .borrow-badge.blue {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .borrow-badge.orange {
            background: #ffedd5;
            color: #ea580c;
        }

        .borrow-form {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
            align-items: end;
        }

        .borrow-form.return-form {
            grid-template-columns: minmax(0, 1fr);
        }

        .borrow-field label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 900;
        }

        .borrow-input {
            width: 100%;
            box-sizing: border-box;
            height: 44px;
            padding: 0 14px;
            border-radius: 14px;
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #0f172a;
            font-size: 14px;
            outline: none;
            transition: .16s ease;
        }

        .borrow-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .10);
        }

        .borrow-field.days {
            max-width: 180px;
        }

        .borrow-submit {
            width: 100%;
            height: 46px;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 950;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            box-shadow: 0 14px 24px rgba(37, 99, 235, .20);
        }

        .borrow-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 28px rgba(37, 99, 235, .26);
        }

        .borrow-submit.orange {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            box-shadow: 0 14px 24px rgba(249, 115, 22, .20);
        }

        .borrow-tip {
            margin-top: 16px;
            padding: 13px 14px;
            border-radius: 16px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            color: #64748b;
            font-size: 13px;
            line-height: 1.7;
        }

        .borrow-section {
            background: #fff;
            border: 1px solid #dbeafe;
            border-radius: 24px;
            box-shadow: 0 18px 38px rgba(15, 23, 42, .055);
            overflow: hidden;
        }

        .borrow-section-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 22px 24px 16px;
        }

        .borrow-section-head h2 {
            margin: 0 0 7px;
            color: #0f172a;
            font-size: 20px;
            font-weight: 950;
        }

        .borrow-section-head p {
            margin: 0;
            color: #64748b;
            font-size: 13px;
            line-height: 1.7;
        }

        .borrow-section-count {
            padding: 8px 14px;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            font-size: 13px;
            font-weight: 950;
            white-space: nowrap;
        }

        .borrow-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        .borrow-table {
            width: 100%;
            min-width: 920px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .borrow-table th {
            padding: 13px 14px;
            background: #eff6ff;
            color: #1e3a8a;
            font-size: 13px;
            font-weight: 950;
            text-align: left;
            border-bottom: 1px solid #dbeafe;
        }

        .borrow-table th:first-child {
            border-radius: 14px 0 0 14px;
        }

        .borrow-table th:last-child {
            border-radius: 0 14px 14px 0;
        }

        .borrow-table td {
            padding: 14px;
            color: #0f172a;
            font-size: 14px;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
        }

        .borrow-table tr:hover td {
            background: #f8fafc;
        }

        .borrow-copy {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 9px;
            background: #f1f5f9;
            color: #334155;
            font-family: Consolas, Monaco, monospace;
            font-size: 12px;
            font-weight: 900;
        }

        .borrow-status {
            display: inline-flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 950;
        }

        .borrow-status.blue {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .borrow-status.green {
            background: #dcfce7;
            color: #166534;
        }

        .borrow-status.orange {
            background: #ffedd5;
            color: #c2410c;
        }

        .borrow-status.red {
            background: #fee2e2;
            color: #b91c1c;
        }

        .borrow-small-btn {
            height: 34px;
            padding: 0 13px;
            border: none;
            border-radius: 11px;
            background: #16a34a;
            color: #fff;
            font-size: 13px;
            font-weight: 950;
            cursor: pointer;
        }

        .borrow-small-btn:hover {
            background: #15803d;
        }

        .borrow-empty {
            padding: 28px 16px !important;
            text-align: center;
            color: #94a3b8 !important;
            font-weight: 800;
            background: #fff !important;
        }

        @media (max-width: 1280px) {
            .borrow-hero,
            .borrow-workbench {
                grid-template-columns: 1fr;
            }

            .borrow-stats {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .borrow-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .borrow-stats,
            .borrow-form {
                grid-template-columns: 1fr;
            }

            .borrow-field.days {
                max-width: none;
            }

            .borrow-section-head {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="borrow-shell">
            <header class="borrow-head">
                <div>
                    <h1>借阅管理</h1>
                    <p>普通管理员办理借书、还书和上架确认；读者端只负责查询图书状态，不直接借书。</p>
                </div>
                <div class="borrow-head-actions">
                    <span class="borrow-pill"><i class="borrow-pill-dot"></i>实体书编码流转</span>
                    <span class="borrow-pill"><i class="borrow-pill-dot"></i>普通管理员业务页</span>
                </div>
            </header>

            <c:if test="${not empty param.success}">
                <div class="borrow-alert success">${param.success}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="borrow-alert error">${param.error}</div>
            </c:if>

            <c:if test="${not empty autoShelfCount && autoShelfCount > 0}">
                <div class="borrow-alert success">系统已自动上架 ${autoShelfCount} 本超过 2 天上架期的图书。</div>
            </c:if>

            <section class="borrow-hero">
                <div class="borrow-hero-main">
                    <h2>实体书编码借阅流程</h2>
                    <p>
                        借书时输入读者编号和图书实体编码；还书后图书先进入“上架中”，
                        两天后自动恢复为“已上架”，也可以由管理员手动确认上架。
                        这样可以避免归还图书立刻显示可借，符合真实图书馆的回收、整理和上架流程。
                    </p>

                    <div class="borrow-flow">
                        <span>已上架</span>
                        <i>→</i>
                        <span>借出中</span>
                        <i>→</i>
                        <span>上架中</span>
                        <i>→</i>
                        <span>已上架</span>
                    </div>
                </div>

                <div class="borrow-stats">
                    <div class="borrow-stat">
                        <strong>${empty recentBorrows ? 0 : fn:length(recentBorrows)}</strong>
                        <span>最近借阅</span>
                    </div>
                    <div class="borrow-stat">
                        <strong>${empty processingCopies ? 0 : fn:length(processingCopies)}</strong>
                        <span>上架中</span>
                    </div>
                    <div class="borrow-stat">
                        <strong>${empty overdueList ? 0 : fn:length(overdueList)}</strong>
                        <span>逾期提醒</span>
                    </div>
                </div>
            </section>

            <section class="borrow-workbench">
                <div class="borrow-card">
                    <div class="borrow-card-inner">
                        <div class="borrow-card-head">
                            <div>
                                <h2>办理借书</h2>
                                <p>输入读者编号/学号/用户名/姓名和实体书编码后办理借出。</p>
                            </div>
                            <span class="borrow-badge blue">BORROW</span>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/borrow">
                            <div class="borrow-form">
                                <div class="borrow-field">
                                    <label>读者编号 / 学号 / 用户名 / 姓名</label>
                                    <input class="borrow-input" type="text" name="readerKeyword" placeholder="例如 R2026001" required>
                                </div>

                                <div class="borrow-field">
                                    <label>图书实体编码</label>
                                    <input class="borrow-input" type="text" name="copyNo" placeholder="例如 B2026001-001" required>
                                </div>

                                <div class="borrow-field days">
                                    <label>借阅天数</label>
                                    <input class="borrow-input" type="number" name="borrowDays" value="30" min="1" max="90" required>
                                </div>

                                <div class="borrow-field">
                                    <label>&nbsp;</label>
                                    <button class="borrow-submit" type="submit">确认借出</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="borrow-card">
                    <div class="borrow-card-inner">
                        <div class="borrow-card-head">
                            <div>
                                <h2>办理还书</h2>
                                <p>输入归还图书的实体编码，归还后进入“上架中”。</p>
                            </div>
                            <span class="borrow-badge orange">RETURN</span>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/return">
                            <div class="borrow-form return-form">
                                <div class="borrow-field">
                                    <label>图书实体编码</label>
                                    <input class="borrow-input" type="text" name="copyNo" placeholder="例如 B2026001-001" required>
                                </div>

                                <div class="borrow-field">
                                    <button class="borrow-submit orange" type="submit">确认归还并进入上架中</button>
                                </div>
                            </div>
                        </form>

                        <div class="borrow-tip">
                            逾期归还时，系统会自动生成或更新罚款记录；归还后的图书不会立即回到书架。
                        </div>
                    </div>
                </div>
            </section>

            <section class="borrow-section">
                <div class="borrow-section-head">
                    <div>
                        <h2>上架处理中</h2>
                        <p>已归还但尚未回到书架的图书。达到预计上架时间后访问本页面会自动上架，也可以手动确认。</p>
                    </div>
                    <div class="borrow-section-count">${empty processingCopies ? 0 : fn:length(processingCopies)} 本</div>
                </div>

                <div class="borrow-table-wrap">
                    <table class="borrow-table">
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
                                <td><span class="borrow-copy">${c.copyNo}</span></td>
                                <td>${c.bookName}</td>
                                <td>${fn:replace(c.returnProcessStartTime, 'T', ' ')}</td>
                                <td>${fn:replace(c.availableAt, 'T', ' ')}</td>
                                <td><span class="borrow-status orange">上架中</span></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/v2/borrows/shelf" style="display:inline;">
                                        <input type="hidden" name="copyId" value="${c.id}">
                                        <button class="borrow-small-btn" type="submit">确认上架</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty processingCopies}">
                            <tr>
                                <td class="borrow-empty" colspan="6">暂无上架中的图书</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="borrow-section">
                <div class="borrow-section-head">
                    <div>
                        <h2>最近借阅记录</h2>
                        <p>查看最新借出、归还和逾期归还记录。</p>
                    </div>
                </div>

                <div class="borrow-table-wrap">
                    <table class="borrow-table">
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
                                <td><span class="borrow-copy">${empty b.copyNo ? '-' : b.copyNo}</span></td>
                                <td>${fn:replace(b.borrowDate, 'T', ' ')}</td>
                                <td>${fn:replace(b.dueDate, 'T', ' ')}</td>
                                <td>${empty b.returnDate ? '-' : fn:replace(b.returnDate, 'T', ' ')}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'BORROWED'}">
                                            <span class="borrow-status blue">借出中</span>
                                        </c:when>
                                        <c:when test="${b.status == 'RETURNED'}">
                                            <span class="borrow-status green">已归还</span>
                                        </c:when>
                                        <c:when test="${b.status == 'OVERDUE_RETURNED'}">
                                            <span class="borrow-status red">逾期已归还</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="borrow-status orange">${b.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty recentBorrows}">
                            <tr>
                                <td class="borrow-empty" colspan="7">暂无借阅记录</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="borrow-section">
                <div class="borrow-section-head">
                    <div>
                        <h2>逾期提醒</h2>
                        <p>展示当前逾期未还图书、逾期天数和预计罚款。</p>
                    </div>
                </div>

                <div class="borrow-table-wrap">
                    <table class="borrow-table">
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
                                <td><span class="borrow-copy">${empty o.copyNo ? '-' : o.copyNo}</span></td>
                                <td>${fn:replace(o.dueDate, 'T', ' ')}</td>
                                <td><span class="borrow-status red">${o.overdueDays} 天</span></td>
                                <td>${o.fine}</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty overdueList}">
                            <tr>
                                <td class="borrow-empty" colspan="6">暂无逾期记录</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>
</body>
</html>

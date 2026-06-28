<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的借阅 - 图书馆读者端</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">

    <style>
        .reader-borrow-page {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .reader-page-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 4px;
        }

        .reader-page-head h1 {
            margin: 0 0 8px;
            font-size: 28px;
            font-weight: 900;
            color: #0f172a;
        }

        .reader-page-head p {
            margin: 0;
            color: #64748b;
            font-size: 15px;
            line-height: 1.7;
        }

        .reader-alert {
            padding: 13px 16px;
            border-radius: 14px;
            font-size: 14px;
            font-weight: 800;
        }

        .reader-alert.success {
            background: #ecfdf5;
            color: #166534;
            border: 1px solid #86efac;
        }

        .reader-alert.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .reader-card {
            background: #ffffff;
            border: 1px solid #dbeafe;
            border-radius: 22px;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.055);
            overflow: hidden;
        }

        .reader-card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 22px 24px 14px;
        }

        .reader-card-head h2 {
            margin: 0;
            font-size: 22px;
            font-weight: 900;
            color: #0f172a;
        }

        .reader-card-head p {
            margin: 8px 0 0;
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .reader-count-pill {
            flex: 0 0 auto;
            padding: 8px 14px;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            font-size: 13px;
            font-weight: 900;
        }

        .reader-table-wrap {
            padding: 0 18px 18px;
            overflow-x: auto;
        }

        .reader-table {
            width: 100%;
            min-width: 980px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .reader-table th {
            padding: 13px 14px;
            background: #eaf2ff;
            color: #1e3a8a;
            font-size: 14px;
            font-weight: 900;
            text-align: left;
            border-bottom: 1px solid #dbeafe;
        }

        .reader-table th:first-child {
            border-radius: 12px 0 0 12px;
        }

        .reader-table th:last-child {
            border-radius: 0 12px 12px 0;
        }

        .reader-table td {
            padding: 14px;
            color: #0f172a;
            font-size: 14px;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
        }

        .reader-table tr:hover td {
            background: #f8fafc;
        }

        .book-title-cell {
            font-weight: 800;
            color: #0f172a;
        }

        .status-tag {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .status-tag.ok {
            background: #dcfce7;
            color: #166534;
        }

        .status-tag.warn {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-tag.done {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .renew-form {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
            max-width: 560px;
        }

        .renew-input {
            flex: 1;
            min-width: 260px;
            height: 38px;
            padding: 0 13px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            background: #ffffff;
            color: #0f172a;
            font-size: 14px;
            outline: none;
            box-sizing: border-box;
        }

        .renew-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.10);
        }

        .renew-btn {
            flex: 0 0 auto;
            height: 38px;
            padding: 0 18px;
            border: none;
            border-radius: 12px;
            background: #2563eb;
            color: #ffffff;
            font-size: 14px;
            font-weight: 900;
            cursor: pointer;
            white-space: nowrap;
            box-shadow: 0 10px 18px rgba(37, 99, 235, 0.18);
        }

        .renew-btn:hover {
            background: #1d4ed8;
        }

        .no-action {
            color: #94a3b8;
            font-size: 13px;
            font-weight: 700;
        }

        .reader-empty {
            padding: 28px 16px !important;
            text-align: center;
            color: #94a3b8 !important;
            font-weight: 800;
            background: #ffffff !important;
        }

        @media (max-width: 900px) {
            .reader-page-head {
                flex-direction: column;
            }

            .renew-form {
                max-width: none;
            }

            .renew-input {
                min-width: 180px;
            }
        }
    </style>
</head>

<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="reader-borrow-page">
            <header class="reader-page-head">
                <div>
                    <h1>我的借阅</h1>
                    <p>当前借阅、历史借阅、逾期提醒与续借申请。</p>
                </div>
            </header>

            <c:if test="${not empty param.success}">
                <div class="reader-alert success">${param.success}</div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="reader-alert error">${param.error}</div>
            </c:if>

            <section class="reader-card">
                <div class="reader-card-head">
                    <div>
                        <h2>当前借阅</h2>
                        <p>未归还图书列表。正常借阅中的图书可以填写续借理由并提交申请。</p>
                    </div>
                    <div class="reader-count-pill">${empty currentList ? 0 : fn:length(currentList)} 本</div>
                </div>

                <div class="reader-table-wrap">
                    <table class="reader-table">
                        <thead>
                        <tr>
                            <th style="width: 22%;">图书</th>
                            <th style="width: 16%;">借出日期</th>
                            <th style="width: 16%;">应还日期</th>
                            <th style="width: 10%;">续借次数</th>
                            <th style="width: 10%;">状态</th>
                            <th style="width: 26%;">操作</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${currentList}" var="b">
                            <tr>
                                <td class="book-title-cell">${b.bookName}</td>
                                <td>${b.borrowDate}</td>
                                <td>${b.dueDate}</td>
                                <td>${empty b.renewCount ? 0 : b.renewCount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.overdueFlag == 1}">
                                            <span class="status-tag warn">逾期</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-tag ok">正常</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'BORROWED' && b.overdueFlag != 1}">
                                            <form class="renew-form"
                                                  method="post"
                                                  action="${pageContext.request.contextPath}/reader/v2/renews/apply">
                                                <input type="hidden" name="borrowRecordId" value="${b.id}">
                                                <input class="renew-input"
                                                       type="text"
                                                       name="reason"
                                                       placeholder="续借理由"
                                                       maxlength="100"
                                                       required>
                                                <button class="renew-btn" type="submit">申请续借</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-action">当前状态不可续借</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty currentList}">
                            <tr>
                                <td class="reader-empty" colspan="6">暂无当前借阅记录</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="reader-card">
                <div class="reader-card-head">
                    <div>
                        <h2>历史借阅</h2>
                        <p>已经归还的历史借阅记录。</p>
                    </div>
                    <div class="reader-count-pill">${empty historyList ? 0 : fn:length(historyList)} 条</div>
                </div>

                <div class="reader-table-wrap">
                    <table class="reader-table">
                        <thead>
                        <tr>
                            <th style="width: 28%;">图书</th>
                            <th style="width: 18%;">借出</th>
                            <th style="width: 18%;">归还</th>
                            <th style="width: 14%;">罚款</th>
                            <th style="width: 14%;">状态</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${historyList}" var="b">
                            <tr>
                                <td class="book-title-cell">${b.bookName}</td>
                                <td>${b.borrowDate}</td>
                                <td>${empty b.returnDate ? '-' : b.returnDate}</td>
                                <td>${empty b.fine ? 0 : b.fine}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status == 'RETURNED'}">
                                            <span class="status-tag done">已归还</span>
                                        </c:when>
                                        <c:when test="${b.status == 'OVERDUE_RETURNED'}">
                                            <span class="status-tag warn">逾期已还</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-tag done">${b.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty historyList}">
                            <tr>
                                <td class="reader-empty" colspan="5">暂无历史借阅记录</td>
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
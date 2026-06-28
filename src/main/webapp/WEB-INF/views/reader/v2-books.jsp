<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书查询 - 图书馆读者端</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css">

    <style>
        .reader-books-page {
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

        .reader-search-card {
            padding: 22px 24px;
            border-radius: 22px;
            background: #ffffff;
            border: 1px solid #dbeafe;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.055);
        }

        .reader-search-form {
            display: grid;
            grid-template-columns: minmax(260px, 1.2fr) minmax(180px, 0.8fr) minmax(180px, 0.8fr) 150px;
            gap: 14px;
            align-items: end;
        }

        .reader-field label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 900;
        }

        .reader-input,
        .reader-select {
            width: 100%;
            height: 42px;
            padding: 0 13px;
            box-sizing: border-box;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            background: #ffffff;
            color: #0f172a;
            font-size: 14px;
            outline: none;
        }

        .reader-input:focus,
        .reader-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.10);
        }

        .reader-search-btn {
            width: 100%;
            height: 42px;
            border: none;
            border-radius: 12px;
            background: #2563eb;
            color: #ffffff;
            font-size: 14px;
            font-weight: 900;
            cursor: pointer;
            box-shadow: 0 12px 22px rgba(37, 99, 235, 0.18);
        }

        .reader-search-btn:hover {
            background: #1d4ed8;
        }

        .reader-book-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
        }

        .reader-book-card {
            position: relative;
            display: flex;
            flex-direction: column;
            min-height: 220px;
            padding: 20px;
            border-radius: 22px;
            background: #ffffff;
            border: 1px solid #dbeafe;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.055);
            overflow: hidden;
        }

        .reader-book-card:before {
            content: "";
            position: absolute;
            right: -36px;
            top: -36px;
            width: 96px;
            height: 96px;
            border-radius: 999px;
            background: #eff6ff;
        }

        .reader-book-card h3 {
            position: relative;
            z-index: 1;
            margin: 0 0 14px;
            color: #0f172a;
            font-size: 19px;
            font-weight: 900;
            line-height: 1.4;
        }

        .reader-book-meta {
            position: relative;
            z-index: 1;
            margin: 0 0 10px;
            color: #334155;
            font-size: 14px;
            line-height: 1.6;
        }

        .reader-book-publisher {
            position: relative;
            z-index: 1;
            margin: 0 0 14px;
            color: #475569;
            font-size: 14px;
            line-height: 1.6;
        }

        .reader-book-status {
            position: relative;
            z-index: 1;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 4px 0 12px;
        }

        .status-chip {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 9px;
            border-radius: 999px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #334155;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .status-chip strong {
            color: #1d4ed8;
            font-weight: 900;
        }

        .reader-book-current {
            position: relative;
            z-index: 1;
            margin-top: auto;
            padding-top: 12px;
            border-top: 1px dashed #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .current-status {
            display: inline-flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 999px;
            background: #dcfce7;
            color: #166534;
            font-size: 12px;
            font-weight: 900;
        }

        .current-status.warn {
            background: #ffedd5;
            color: #c2410c;
        }

        .book-detail-link {
            color: #2563eb;
            font-size: 13px;
            font-weight: 900;
            text-decoration: none;
            white-space: nowrap;
        }

        .book-detail-link:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }

        .reader-empty-card {
            padding: 42px 20px;
            text-align: center;
            color: #94a3b8;
            font-size: 15px;
            font-weight: 800;
            border-radius: 22px;
            background: #ffffff;
            border: 1px solid #dbeafe;
        }

        @media (max-width: 1280px) {
            .reader-book-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 1000px) {
            .reader-search-form {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .reader-book-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            .reader-page-head {
                flex-direction: column;
            }

            .reader-search-form {
                grid-template-columns: 1fr;
            }

            .reader-book-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body class="v2-body">
<div class="v2-layout">
    <jsp:include page="v2-sidebar.jsp"/>

    <main class="v2-main">
        <div class="reader-books-page">
            <header class="reader-page-head">
                <div>
                    <h1>图书查询</h1>
                    <p>读者端仅查询图书状态。如需借阅，请到图书馆服务台由普通管理员办理。</p>
                </div>
            </header>

            <section class="reader-search-card">
                <form class="reader-search-form"
                      method="get"
                      action="${pageContext.request.contextPath}/reader/v2/books">

                    <div class="reader-field">
                        <label>关键词</label>
                        <input class="reader-input"
                               type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="书名 / 编号 / 作者 / 出版社">
                    </div>

                    <div class="reader-field">
                        <label>分类</label>
                        <select class="reader-select" name="categoryId">
                            <option value="" ${empty categoryId ? "selected" : ""}>全部</option>
                            <c:forEach items="${categories}" var="c">
                                <option value="${c.id}" ${categoryId == c.id ? "selected" : ""}>
                                    ${c.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="reader-field">
                        <label>推荐</label>
                        <select class="reader-select" name="recommend">
                            <option value="" ${empty recommend ? "selected" : ""}>不限</option>
                            <option value="1" ${recommend == 1 ? "selected" : ""}>只看推荐</option>
                        </select>
                    </div>

                    <div class="reader-field">
                        <label>&nbsp;</label>
                        <button class="reader-search-btn" type="submit">查询</button>
                    </div>
                </form>
            </section>

            <c:choose>
                <c:when test="${not empty books}">
                    <section class="reader-book-grid">
                        <c:forEach items="${books}" var="b">
                            <article class="reader-book-card">
                                <h3>${b.bookName}</h3>

                                <p class="reader-book-meta">${b.author}</p>

                                <p class="reader-book-publisher">
                                    ${b.publisher}
                                    <c:if test="${not empty b.categoryName}">
                                        / ${b.categoryName}
                                    </c:if>
                                </p>

                                <div class="reader-book-status">
                                    <span class="status-chip">
                                        馆藏 <strong>${empty b.totalCopyCount ? b.totalCount : b.totalCopyCount}</strong>
                                    </span>

                                    <span class="status-chip">
                                        已上架 <strong>${empty b.onShelfCount ? b.availableCount : b.onShelfCount}</strong>
                                    </span>

                                    <span class="status-chip">
                                        借出中 <strong>${empty b.borrowedCopyCount ? b.borrowCount : b.borrowedCopyCount}</strong>
                                    </span>

                                    <span class="status-chip">
                                        上架中 <strong>${empty b.processingCount ? 0 : b.processingCount}</strong>
                                    </span>
                                </div>

                                <div class="reader-book-current">
                                    <c:choose>
                                        <c:when test="${b.displayStatus == '可借'}">
                                            <span class="current-status">当前状态：可借</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="current-status warn">当前状态：${b.displayStatus}</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <a class="book-detail-link"
                                       href="${pageContext.request.contextPath}/reader/v2/books/${b.id}">
                                        查看详情
                                    </a>
                                </div>
                            </article>
                        </c:forEach>
                    </section>
                </c:when>

                <c:otherwise>
                    <div class="reader-empty-card">暂无符合条件的图书</div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>
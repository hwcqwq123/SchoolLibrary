<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${action == 'add' ? '新增图书' : '修改图书'}</title>

    <%-- 【本次修改】恢复全局样式文件 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>

<%@ include file="../common/admin-header.jsp" %>

<div class="page-container">

    <%-- 【本次修改】恢复页面标题区域结构 --%>
    <div class="page-title-row">
        <div>
            <h2>${action == 'add' ? '新增图书' : '修改图书'}</h2>
            <p class="page-subtitle">
                ${action == 'add' ? '录入新的馆藏图书信息' : '修改图书基础信息、库存、封面与推荐状态'}
            </p>
        </div>
        <div>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/books">返回列表</a>
        </div>
    </div>

    <%-- 【本次修改】恢复表单卡片样式 --%>
    <div class="card form-card">

        <%-- 【本次修改】新增 enctype="multipart/form-data"，用于上传图书封面 --%>
        <form action="${pageContext.request.contextPath}/admin/book/${action}"
              method="post"
              enctype="multipart/form-data"
              class="form-box">

            <c:if test="${action == 'edit'}">
                <input type="hidden" name="id" value="${book.id}">
            </c:if>

            <div class="form-grid">

                <div class="form-row">
                    <label>图书编号</label>
                    <input type="text" name="bookNo" value="${book.bookNo}" required>
                </div>

                <%-- 【本次修改】新增 ISBN 字段 --%>
                <div class="form-row">
                    <label>ISBN</label>
                    <input type="text" name="isbn" value="${book.isbn}">
                </div>

                <div class="form-row">
                    <label>书名</label>
                    <input type="text" name="bookName" value="${book.bookName}" required>
                </div>

                <div class="form-row">
                    <label>作者</label>
                    <input type="text" name="author" value="${book.author}">
                </div>

                <div class="form-row">
                    <label>出版社</label>
                    <input type="text" name="publisher" value="${book.publisher}">
                </div>

                <div class="form-row">
                    <label>分类</label>
                    <input type="text" name="category" value="${book.category}">
                </div>

                <div class="form-row">
                    <label>总库存</label>
                    <input type="number" name="totalCount" value="${book.totalCount}" min="0" required>
                </div>

                <div class="form-row">
                    <label>可借库存</label>
                    <input type="number" name="availableCount" value="${book.availableCount}" min="0">
                </div>

                <div class="form-row">
                    <label>馆藏位置</label>
                    <input type="text" name="location" value="${book.location}">
                </div>

                <%-- 【本次修改】新增推荐标记 --%>
                <div class="form-row">
                    <label>是否推荐</label>
                    <select name="recommendFlag">
                        <option value="0" ${book.recommendFlag == 0 ? 'selected' : ''}>否</option>
                        <option value="1" ${book.recommendFlag == 1 ? 'selected' : ''}>是</option>
                    </select>
                </div>
            </div>

            <%-- 【本次修改】新增图书简介 --%>
            <div class="form-row">
                <label>图书简介</label>
                <textarea name="description" rows="4">${book.description}</textarea>
            </div>

            <%-- 【本次修改】新增图书封面上传 --%>
            <div class="form-row">
                <label>图书封面</label>

                <div class="upload-preview-row">
                    <div class="cover-preview-box">
                        <c:choose>
                            <c:when test="${not empty book.coverImage}">
                                <img src="${pageContext.request.contextPath}${book.coverImage}"
                                     alt="图书封面"
                                     class="book-cover-lg">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/img/default-book.svg"
                                     alt="默认封面"
                                     class="book-cover-lg">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="upload-control">
                        <input type="file" name="coverFile" accept="image/*">
                        <p class="form-help">支持 jpg、jpeg、png、gif、webp 格式。修改时不上传新图片则保留原封面。</p>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">保存</button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/books">取消</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

</body>
</html>
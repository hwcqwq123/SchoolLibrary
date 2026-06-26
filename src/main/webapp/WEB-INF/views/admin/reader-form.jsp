<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>读者表单</title>
    <link rel="stylesheet" href="${ctx}/assets/css/app.css">
</head>
<body>
<%@ include file="../common/admin-header.jsp" %>
<h2>${action == 'add' ? '新增读者' : '修改读者'}</h2>
<form class="form" method="post" action="${ctx}/admin/reader/${action}">
    <input type="hidden" name="id" value="${reader.id}">
    <label>读者编号</label>
    <input name="readerNo" value="${reader.readerNo}" ${action == 'edit' ? 'readonly' : ''} required>
    <label>姓名</label>
    <input name="name" value="${reader.name}" required>
    <label>性别</label>
    <select name="gender">
        <option value="男" ${reader.gender == '男' ? 'selected' : ''}>男</option>
        <option value="女" ${reader.gender == '女' ? 'selected' : ''}>女</option>
    </select>
    <label>电话</label>
    <input name="phone" value="${reader.phone}">
    <label>邮箱</label>
    <input name="email" value="${reader.email}">
    <label>院系/部门</label>
    <input name="department" value="${reader.department}">
    <p class="hint">新增读者默认登录密码为：123456。</p>
    <button class="btn primary" type="submit">保存</button>
    <a class="btn" href="${ctx}/admin/readers">返回</a>
</form>
<%@ include file="../common/footer.jsp" %>
</body>
</html>



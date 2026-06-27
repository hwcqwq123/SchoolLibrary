<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>公告管理 - 图书馆管理系统</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/v2.css"></head>
<body class="v2-body"><div class="v2-layout">
<jsp:include page="v2-sidebar.jsp"><jsp:param name="active" value="notices"/></jsp:include>
<main class="v2-main">
    <div class="v2-page-head"><div><h1>公告管理</h1><p>发布、修改和隐藏图书馆公告。</p></div></div>
    <section class="v2-card"><form class="v2-form three" method="get" action="${pageContext.request.contextPath}/admin/v2/notices">
        <div><label>关键词</label><input class="v2-input" name="keyword" value="${keyword}" placeholder="标题 / 内容"></div><button class="v2-btn primary" type="submit">查询</button>
    </form></section>
    <section class="v2-card"><h2>新增公告</h2><form class="v2-form three" method="post" action="${pageContext.request.contextPath}/admin/v2/notices/add">
        <div><label>标题</label><input class="v2-input" name="title" required></div><div><label>内容</label><input class="v2-input" name="content" required></div><div><label>状态</label><select class="v2-select" name="status"><option value="1">显示</option><option value="0">隐藏</option></select></div><button class="v2-btn primary" type="submit">发布</button>
    </form></section>
    <section class="v2-card"><table class="v2-table">
        <tr><th>标题</th><th>内容</th><th>发布人</th><th>状态</th><th>时间</th><th>快速修改</th><th>操作</th></tr>
        <c:forEach items="${list}" var="n"><tr>
            <td>${n.title}</td><td>${n.content}</td><td>${n.publisherName}</td><td><span class="v2-tag ${n.status==1?'ok':'danger'}">${n.status==1?'显示':'隐藏'}</span></td><td>${fn:replace(n.createTime, 'T', ' ')}</td>
            <td><form class="v2-form one" method="post" action="${pageContext.request.contextPath}/admin/v2/notices/update"><input type="hidden" name="id" value="${n.id}"><input class="v2-input" name="title" value="${n.title}"><textarea class="v2-textarea" name="content">${n.content}</textarea><select class="v2-select" name="status"><option value="1" ${n.status==1?'selected':''}>显示</option><option value="0" ${n.status==0?'selected':''}>隐藏</option></select><button class="v2-btn ok" type="submit">保存</button></form></td>
            <td><a class="v2-btn danger" href="${pageContext.request.contextPath}/admin/v2/notices/delete/${n.id}" onclick="return confirm('确认删除/下线？')">删除</a></td>
        </tr></c:forEach>
        <c:if test="${empty list}"><tr><td colspan="7" class="v2-empty">暂无公告</td></tr></c:if>
    </table></section>
</main></div></body></html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>无权限访问</title>
    <style>
        body { margin:0; font-family:"Microsoft YaHei", Arial, sans-serif; background:#f3f6fb; color:#1f2937; }
        .box { width:520px; margin:100px auto; background:#fff; border-radius:18px; padding:32px; box-shadow:0 18px 45px rgba(15,23,42,.12); text-align:center; }
        h1 { margin:0 0 12px; font-size:30px; color:#dc2626; }
        p { color:#64748b; }
        a { display:inline-block; margin-top:18px; padding:10px 18px; border-radius:10px; background:#2563eb; color:#fff; text-decoration:none; font-weight:700; }
    </style>
</head>
<body>
<div class="box">
    <h1>403</h1>
    <p>当前账号无权限访问该页面。</p>
    <a href="${pageContext.request.contextPath}/login">返回登录页</a>
</div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理系统登录</title>

    <%--
        【本次修改】
        这里不再依赖 app.css 的登录页样式。
        原因：
        你当前 app.css 中可能存在旧样式或其他全局样式冲突，导致登录页布局错乱。
        本页面使用 login-v2 前缀的独立样式，避免影响其他页面。
    --%>
    <style>
        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background: linear-gradient(135deg, #eaf1ff 0%, #f7f9fc 45%, #e8eef8 100%);
            color: #1e293b;
        }

        .login-v2-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .login-v2-container {
            width: 980px;
            min-height: 560px;
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            border-radius: 28px;
            overflow: hidden;
            background: #ffffff;
            box-shadow: 0 28px 80px rgba(15, 23, 42, 0.16);
            border: 1px solid #dbe4f0;
        }

        .login-v2-left {
            padding: 46px;
            background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 52%, #38bdf8 100%);
            color: #ffffff;
            position: relative;
            overflow: hidden;
        }

        .login-v2-left::before {
            content: "";
            position: absolute;
            right: -80px;
            top: -80px;
            width: 240px;
            height: 240px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.16);
        }

        .login-v2-left::after {
            content: "";
            position: absolute;
            left: -90px;
            bottom: -90px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.10);
        }

        .login-v2-brand {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 48px;
        }

        .login-v2-logo {
            width: 66px;
            height: 66px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.22);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            font-weight: 900;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.28);
        }

        .login-v2-brand h1 {
            margin: 0;
            font-size: 30px;
            line-height: 1.2;
            font-weight: 900;
            letter-spacing: 1px;
        }

        .login-v2-brand p {
            margin: 8px 0 0;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.82);
        }

        .login-v2-features {
            position: relative;
            z-index: 1;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .login-v2-feature {
            display: flex;
            gap: 16px;
            padding: 18px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.20);
            backdrop-filter: blur(6px);
        }

        .login-v2-feature-num {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.24);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            flex: 0 0 auto;
        }

        .login-v2-feature strong {
            display: block;
            font-size: 16px;
            margin-bottom: 6px;
        }

        .login-v2-feature p {
            margin: 0;
            font-size: 13px;
            line-height: 1.7;
            color: rgba(255, 255, 255, 0.84);
        }

        .login-v2-right {
            padding: 52px 46px;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-v2-card-title {
            margin-bottom: 28px;
        }

        .login-v2-card-title h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 900;
            color: #172033;
        }

        .login-v2-card-title p {
            margin: 10px 0 0;
            color: #64748b;
            font-size: 14px;
        }

        .login-v2-error {
            padding: 12px 14px;
            margin-bottom: 18px;
            border-radius: 12px;
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            font-size: 14px;
            font-weight: 600;
        }

        .login-v2-form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .login-v2-row label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 14px;
            font-weight: 800;
        }

        .login-v2-row input,
        .login-v2-row select {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border-radius: 13px;
            border: 1px solid #cfd8e6;
            background: #f8fbff;
            color: #1f2937;
            font-size: 15px;
            outline: none;
            transition: all 0.2s ease;
        }

        .login-v2-row input:focus,
        .login-v2-row select:focus {
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .login-v2-submit {
            width: 100%;
            height: 48px;
            margin-top: 6px;
            border: none;
            border-radius: 14px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            font-size: 16px;
            font-weight: 900;
            cursor: pointer;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.28);
            transition: all 0.2s ease;
        }

        .login-v2-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 16px 30px rgba(37, 99, 235, 0.36);
        }

        .login-v2-demo {
            margin-top: 24px;
            padding: 15px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            color: #64748b;
            font-size: 13px;
            line-height: 1.9;
        }

        .login-v2-demo strong {
            color: #1e293b;
        }

        @media (max-width: 900px) {
            .login-v2-page {
                padding: 22px;
            }

            .login-v2-container {
                width: 100%;
                grid-template-columns: 1fr;
            }

            .login-v2-left {
                padding: 34px;
            }

            .login-v2-right {
                padding: 34px;
            }
        }

        @media (max-width: 560px) {
            .login-v2-page {
                padding: 0;
                align-items: stretch;
            }

            .login-v2-container {
                border-radius: 0;
                min-height: 100vh;
            }

            .login-v2-left {
                display: none;
            }

            .login-v2-right {
                padding: 30px 24px;
            }
        }
    </style>
</head>

<body>

<div class="login-v2-page">
    <div class="login-v2-container">

        <%-- 【本次修改】左侧系统介绍区域，使用独立 login-v2 样式 --%>
        <div class="login-v2-left">
            <div class="login-v2-brand">
                <div class="login-v2-logo">书</div>
                <div>
                    <h1>图书管理系统</h1>
                    <p>基于 JavaEE / SSM 的校园图书馆管理平台</p>
                </div>
            </div>

            <div class="login-v2-features">
                <div class="login-v2-feature">
                    <div class="login-v2-feature-num">01</div>
                    <div>
                        <strong>图书管理</strong>
                        <p>支持馆藏图书维护、库存管理、封面上传与分类查询。</p>
                    </div>
                </div>

                <div class="login-v2-feature">
                    <div class="login-v2-feature-num">02</div>
                    <div>
                        <strong>借阅管理</strong>
                        <p>支持读者借书、还书、逾期提醒与续借申请。</p>
                    </div>
                </div>

                <div class="login-v2-feature">
                    <div class="login-v2-feature-num">03</div>
                    <div>
                        <strong>座位预约</strong>
                        <p>后续支持图书馆楼层座位可视化预约与时段管理。</p>
                    </div>
                </div>
            </div>
        </div>

        <%-- 【本次修改】右侧登录卡片 --%>
        <div class="login-v2-right">
            <div class="login-v2-card-title">
                <h2>用户登录</h2>
                <p>请选择身份并输入账号密码</p>
            </div>

            <c:if test="${not empty error}">
                <div class="login-v2-error">${error}</div>
            </c:if>

            <%--
                【本次修改】关键：
                action 必须使用 contextPath，防止登录提交到 /login 导致 404。
            --%>
            <form method="post"
                  action="${pageContext.request.contextPath}/login"
                  class="login-v2-form">

                <div class="login-v2-row">
                    <label>账号</label>
                    <input type="text"
                           name="username"
                           value="${not empty username ? username : 'admin'}"
                           placeholder="请输入账号"
                           required>
                </div>

                <div class="login-v2-row">
                    <label>密码</label>
                    <input type="password"
                           name="password"
                           value="123456"
                           placeholder="请输入密码"
                           required>
                </div>

                <div class="login-v2-row">
                    <label>身份</label>
                    <select name="userType">
                        <option value="admin" ${userType == 'admin' ? 'selected' : ''}>管理员</option>
                        <option value="reader" ${userType == 'reader' ? 'selected' : ''}>读者</option>
                    </select>
                </div>

                <button type="submit" class="login-v2-submit">登录系统</button>
            </form>

            <div class="login-v2-demo">
                <div>默认管理员：<strong>admin / 123456</strong></div>
                <div>超级管理员：<strong>libadmin / 123456</strong></div>
                <div>默认读者：<strong>R2026001 / 123456</strong></div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
package cn.edu.library.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登录与权限拦截器
 *
 * 【本次修改】
 * 修复点击登录后无法跳转的问题。
 *
 * 原因：
 * 之前拦截器读取的是 session.loginRole，
 * 但 LoginController 登录成功后设置的是 session.userType。
 *
 * 所以登录虽然成功了，但访问 /admin/v2/dashboard 时，
 * 拦截器认为 loginRole == null，于是又重定向回 /login。
 *
 * 本次修复：
 * 1. 优先读取 userType。
 * 2. 兼容旧字段 loginRole。
 * 3. 放行 /debug/**，方便后续调试。
 * 4. 管理员页面要求 userType=ADMIN。
 * 5. 读者页面要求 userType=READER。
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        System.out.println("========== [INTERCEPTOR DEBUG] ==========");
        System.out.println("uri = " + uri);
        System.out.println("contextPath = " + contextPath);
        System.out.println("path = " + path);

        /*
         * 【本次修改】
         * 放行登录、退出、静态资源、debug 调试地址。
         */
        if ("/".equals(path)
                || "/login".equals(path)
                || "/logout".equals(path)
                || path.startsWith("/assets/")
                || path.startsWith("/uploads/")
                || path.startsWith("/debug/")) {

            System.out.println("拦截器结论：放行公共路径");
            System.out.println("=========================================");
            return true;
        }

        HttpSession session = request.getSession(false);

        if (session == null) {
            System.out.println("拦截器结论：session 为空，跳转登录页");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        Object user = session.getAttribute("loginUser");

        /*
         * 【本次修改】
         * 统一登录身份字段：
         * 1. 新代码使用 userType。
         * 2. 旧代码如果使用 loginRole，也兼容。
         */
        String userType = (String) session.getAttribute("userType");

        if (userType == null || userType.trim().isEmpty()) {
            userType = (String) session.getAttribute("loginRole");
        }

        System.out.println("sessionId = " + session.getId());
        System.out.println("loginUser = " + user);
        System.out.println("userType = " + session.getAttribute("userType"));
        System.out.println("loginRole = " + session.getAttribute("loginRole"));
        System.out.println("adminRole = " + session.getAttribute("adminRole"));
        System.out.println("resolvedUserType = " + userType);

        if (user == null || userType == null || userType.trim().isEmpty()) {
            System.out.println("拦截器结论：未登录或身份为空，跳转登录页");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        /*
         * 【本次修改】
         * 管理员页面只允许 ADMIN 身份访问。
         */
        if (path.startsWith("/admin") && !"ADMIN".equals(userType)) {
            System.out.println("拦截器结论：非管理员访问管理员页面，跳转 403");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        /*
         * 【本次修改】
         * 读者页面只允许 READER 身份访问。
         */
        if (path.startsWith("/reader") && !"READER".equals(userType)) {
            System.out.println("拦截器结论：非读者访问读者页面，跳转 403");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        System.out.println("拦截器结论：已登录且身份匹配，放行");
        System.out.println("=========================================");
        return true;
    }
}
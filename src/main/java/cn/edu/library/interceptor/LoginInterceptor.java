package cn.edu.library.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录与权限拦截器
 *
 * 【本次修改】
 * 1. 同时兼容 userType 和 loginRole。
 * 2. 放行 /debug/**，方便定位问题。
 * 3. 打印拦截器判断结果，避免之后再出现“不知道为什么跳回登录页”。
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

        if ("/".equals(path)
                || "/login".equals(path)
                || "/logout".equals(path)
                || path.startsWith("/assets/")
                || path.startsWith("/uploads/")
                || path.startsWith("/debug/")
                || path.startsWith("/error/")) {
            System.out.println("拦截器结论：公共路径放行");
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
        String userType = (String) session.getAttribute("userType");
        String loginRole = (String) session.getAttribute("loginRole");

        if (userType == null || userType.trim().isEmpty()) {
            userType = loginRole;
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

        if (path.startsWith("/admin") && !"ADMIN".equals(userType)) {
            System.out.println("拦截器结论：非管理员访问管理员页，跳转 403");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        if (path.startsWith("/reader") && !"READER".equals(userType)) {
            System.out.println("拦截器结论：非读者访问读者页，跳转 403");
            System.out.println("=========================================");
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        System.out.println("拦截器结论：已登录且身份匹配，放行");
        System.out.println("=========================================");
        return true;
    }
}

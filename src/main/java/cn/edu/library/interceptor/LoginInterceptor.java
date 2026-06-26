package cn.edu.library.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录与权限拦截器。
 * 作用：
 * 1. 未登录用户不能直接访问后台或读者页面；
 * 2. 管理员与读者访问范围隔离。
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // 首页、登录页和静态资源放行。
        if ("/".equals(path) || path.startsWith("/assets/") || "/login".equals(path) || "/logout".equals(path)) {
            return true;
        }

        Object user = request.getSession().getAttribute("loginUser");
        String role = (String) request.getSession().getAttribute("loginRole");
        if (user == null || role == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        // 管理员页面必须由管理员访问。
        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }
        // 读者页面必须由读者访问。
        if (path.startsWith("/reader") && !"READER".equals(role)) {
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }
        return true;
    }
}

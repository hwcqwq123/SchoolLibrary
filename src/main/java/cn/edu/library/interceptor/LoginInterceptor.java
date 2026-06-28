package cn.edu.library.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 【本次修改】登录与角色边界拦截器。
 *
 * 角色边界：
 * 1. SUPER_ADMIN：固定唯一 admin，只负责普通管理员账号、操作日志、系统维护。
 * 2. ADMIN：普通管理员，负责图书、读者、借阅、罚款、座位等日常业务。
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isPublicPath(path)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        Object user = session.getAttribute("loginUser");
        String userType = stringValue(session.getAttribute("userType"));
        String loginRole = stringValue(session.getAttribute("loginRole"));

        if (userType.length() == 0) {
            userType = loginRole;
        }

        if (user == null || userType.length() == 0) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        if (path.startsWith("/admin") && !"ADMIN".equals(userType)) {
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        if (path.startsWith("/reader") && !"READER".equals(userType)) {
            response.sendRedirect(contextPath + "/error/403");
            return false;
        }

        if (path.startsWith("/admin")) {
            return checkAdminRoleBoundary(path, session, contextPath, response);
        }

        return true;
    }

    private boolean checkAdminRoleBoundary(String path,
                                           HttpSession session,
                                           String contextPath,
                                           HttpServletResponse response) throws Exception {
        String adminRole = stringValue(session.getAttribute("adminRole"));

        if (isSuperAdminOnlyPath(path)) {
            if (!"SUPER_ADMIN".equals(adminRole)) {
                response.sendRedirect(contextPath + "/admin/v2/dashboard?error="
                        + encode("当前账号为普通管理员，无权访问超级管理员功能。"));
                return false;
            }
            return true;
        }

        if (isNormalAdminOnlyPath(path)) {
            if ("SUPER_ADMIN".equals(adminRole)) {
                response.sendRedirect(contextPath + "/admin/v2/admins?error="
                        + encode("超级管理员不参与读者、图书和借阅等日常业务，请使用普通管理员账号办理。"));
                return false;
            }
            if (!"ADMIN".equals(adminRole)) {
                response.sendRedirect(contextPath + "/error/403");
                return false;
            }
        }

        return true;
    }

    private boolean isPublicPath(String path) {
        return "/".equals(path)
                || "/login".equals(path)
                || "/logout".equals(path)
                || path.startsWith("/assets/")
                || path.startsWith("/uploads/")
                || path.startsWith("/debug/")
                || path.startsWith("/error/");
    }

    private boolean isSuperAdminOnlyPath(String path) {
        return path.startsWith("/admin/v2/admins")
                || path.startsWith("/admin/v2/logs")
                || path.startsWith("/admin/v2/data")
                || path.startsWith("/admin/v2/system")
                || path.startsWith("/admin/system")
                || path.startsWith("/admin/admins")
                || path.startsWith("/admin/logs")
                || path.startsWith("/admin/data")
                || path.startsWith("/admin/export")
                || path.startsWith("/admin/import");
    }

    private boolean isNormalAdminOnlyPath(String path) {
        return path.startsWith("/admin/v2/dashboard")
                || path.startsWith("/admin/v2/books")
                || path.startsWith("/admin/v2/categories")
                || path.startsWith("/admin/v2/readers")
                || path.startsWith("/admin/v2/borrows")
                || path.startsWith("/admin/v2/renews")
                || path.startsWith("/admin/v2/fines")
                || path.startsWith("/admin/v2/seats")
                || path.startsWith("/admin/v2/notices")
                || path.startsWith("/admin/books")
                || path.startsWith("/admin/categories")
                || path.startsWith("/admin/readers")
                || path.startsWith("/admin/borrows")
                || path.startsWith("/admin/borrow")
                || path.startsWith("/admin/renews")
                || path.startsWith("/admin/fines")
                || path.startsWith("/admin/seats")
                || path.startsWith("/admin/notices");
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value).trim();
    }

    private String encode(String text) {
        try {
            return java.net.URLEncoder.encode(text, "UTF-8");
        } catch (Exception e) {
            return text;
        }
    }
}

package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 【本次新增】调试控制器
 *
 * 作用：
 * 1. 测试 SpringMVC 映射是否正常。
 * 2. 查看当前登录 session。
 * 3. 查看常用路径是否正确。
 */
@Controller
public class DebugController {

    /** 【本次新增】访问 /debug/ping 测试 SpringMVC 是否正常。 */
    @GetMapping("/debug/ping")
    @ResponseBody
    public String ping(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();
        sb.append("DEBUG PING OK\n");
        sb.append("contextPath = ").append(request.getContextPath()).append("\n");
        sb.append("requestURI = ").append(request.getRequestURI()).append("\n");
        sb.append("servletPath = ").append(request.getServletPath()).append("\n");
        sb.append("method = ").append(request.getMethod()).append("\n");
        return sb.toString();
    }

    /** 【本次新增】访问 /debug/session 查看当前 session。 */
    @GetMapping("/debug/session")
    @ResponseBody
    public String session(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();
        HttpSession session = request.getSession(false);
        sb.append("DEBUG SESSION\n");
        if (session == null) {
            sb.append("session = null\n");
            return sb.toString();
        }
        sb.append("sessionId = ").append(session.getId()).append("\n");
        sb.append("loginUser = ").append(session.getAttribute("loginUser")).append("\n");
        sb.append("userType = ").append(session.getAttribute("userType")).append("\n");
        sb.append("loginRole = ").append(session.getAttribute("loginRole")).append("\n");
        sb.append("adminRole = ").append(session.getAttribute("adminRole")).append("\n");
        return sb.toString();
    }

    /** 【本次新增】访问 /debug/paths 查看主要页面路径。 */
    @GetMapping("/debug/paths")
    @ResponseBody
    public String paths(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        StringBuilder sb = new StringBuilder();
        sb.append("DEBUG PATHS\n");
        sb.append("login = ").append(contextPath).append("/login\n");
        sb.append("admin dashboard = ").append(contextPath).append("/admin/v2/dashboard\n");
        sb.append("admin books = ").append(contextPath).append("/admin/v2/books\n");
        sb.append("admin readers = ").append(contextPath).append("/admin/v2/readers\n");
        sb.append("admin borrows = ").append(contextPath).append("/admin/v2/borrows\n");
        sb.append("reader home = ").append(contextPath).append("/reader/v2/home\n");
        return sb.toString();
    }
}

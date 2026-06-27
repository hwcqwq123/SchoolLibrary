package cn.edu.library.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 【本次新增】调试控制器
 *
 * 作用：
 * 1. 测试 SpringMVC 映射是否正常。
 * 2. 查看当前 session。
 * 3. 查看常用路径。
 */
@Controller
public class DebugController {

    /**
     * 【本次新增】
     * 访问：
     * http://localhost:8080/SchoolLibrary/debug/ping
     */
    @GetMapping("/debug/ping")
    @ResponseBody
    public String ping(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();

        sb.append("DEBUG PING OK\n");
        sb.append("contextPath = ").append(request.getContextPath()).append("\n");
        sb.append("requestURI = ").append(request.getRequestURI()).append("\n");
        sb.append("servletPath = ").append(request.getServletPath()).append("\n");
        sb.append("method = ").append(request.getMethod()).append("\n");
        sb.append("remoteAddr = ").append(request.getRemoteAddr()).append("\n");

        return sb.toString();
    }

    /**
     * 【本次新增】
     * 访问：
     * http://localhost:8080/SchoolLibrary/debug/session
     */
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

    /**
     * 【本次新增】
     * 访问：
     * http://localhost:8080/SchoolLibrary/debug/paths
     */
    @GetMapping("/debug/paths")
    @ResponseBody
    public String paths(HttpServletRequest request) {
        String contextPath = request.getContextPath();

        StringBuilder sb = new StringBuilder();

        sb.append("DEBUG PATHS\n");
        sb.append("login = ").append(contextPath).append("/login\n");
        sb.append("admin dashboard = ").append(contextPath).append("/admin/v2/dashboard\n");
        sb.append("reader home = ").append(contextPath).append("/reader/v2/home\n");
        sb.append("debug ping = ").append(contextPath).append("/debug/ping\n");
        sb.append("debug session = ").append(contextPath).append("/debug/session\n");

        return sb.toString();
    }
}
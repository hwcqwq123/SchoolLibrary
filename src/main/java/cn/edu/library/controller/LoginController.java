package cn.edu.library.controller;

import cn.edu.library.entity.Admin;
import cn.edu.library.entity.Reader;
import cn.edu.library.service.AdminService;
import cn.edu.library.service.ReaderService;
import cn.edu.library.service.V2BusinessService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 登录控制器。
 *
 * 【本次修改】
 * 1. 登录成功后同时写入 userType 和 loginRole。
 * 2. 登录成功、登录失败、退出登录写入 operation_log。
 * 3. 增加空参数校验，登录失败时给出明确提示。
 */
@Controller
public class LoginController {

    @Resource
    private AdminService adminService;

    @Resource
    private ReaderService readerService;

    @Resource
    private V2BusinessService v2BusinessService;

    @GetMapping({"/login", "/"})
    public String loginPage(HttpServletRequest request) {
        System.out.println("========== [LOGIN PAGE] ==========");
        System.out.println("GET login page");
        System.out.println("requestURI = " + request.getRequestURI());
        System.out.println("contextPath = " + request.getContextPath());
        System.out.println("==================================");
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam(required = false) String username,
                        @RequestParam(required = false) String password,
                        @RequestParam(required = false) String userType,
                        Model model,
                        HttpSession session,
                        HttpServletRequest request) {

        String loginName = username == null ? "" : username.trim();
        String rawPassword = password == null ? "" : password.trim();
        String loginType = userType == null ? "" : userType.trim().toLowerCase();

        if (loginName.isEmpty() || rawPassword.isEmpty()) {
            model.addAttribute("error", "账号和密码不能为空");
            model.addAttribute("username", loginName);
            model.addAttribute("userType", loginType);
            logLogin(request, "UNKNOWN", null, loginName, "登录失败：账号或密码为空");
            return "login";
        }
        if (!"admin".equals(loginType) && !"reader".equals(loginType)) {
            model.addAttribute("error", "请选择正确的登录身份");
            model.addAttribute("username", loginName);
            model.addAttribute("userType", loginType);
            logLogin(request, "UNKNOWN", null, loginName, "登录失败：身份类型错误");
            return "login";
        }

        String md5Lower = Md5Util.md5(rawPassword);
        String md5Upper = md5Lower == null ? "" : md5Lower.toUpperCase();

        System.out.println();
        System.out.println("========== [LOGIN DEBUG START] ==========");
        System.out.println("requestURI = " + request.getRequestURI());
        System.out.println("contextPath = " + request.getContextPath());
        System.out.println("method = " + request.getMethod());
        System.out.println("loginName = " + loginName);
        System.out.println("loginType = " + loginType);
        System.out.println("rawPassword = ******");
        System.out.println("md5Lower = " + md5Lower);
        System.out.println("md5Upper = " + md5Upper);
        System.out.println("sessionId before = " + session.getId());

        if ("admin".equals(loginType)) {
            Admin admin = tryAdminLogin(loginName, rawPassword, md5Lower, md5Upper);
            if (admin != null) {
                session.setAttribute("loginUser", admin);
                session.setAttribute("userType", "ADMIN");
                session.setAttribute("loginRole", "ADMIN");
                session.setAttribute("adminRole", admin.getRole());
                logLogin(request, "ADMIN", admin.getId(), admin.getUsername(), "管理员登录成功");
                System.out.println("[LOGIN RESULT] 管理员登录成功");
                System.out.println("redirect target = /admin/v2/dashboard");
                System.out.println("========== [LOGIN DEBUG END] ==========");
                System.out.println();
                return "redirect:/admin/v2/dashboard?success=登录成功";
            }
        }

        if ("reader".equals(loginType)) {
            Reader reader = tryReaderLogin(loginName, rawPassword, md5Lower, md5Upper);
            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");
                session.setAttribute("loginRole", "READER");
                logLogin(request, "READER", reader.getId(), reader.getName(), "读者登录成功");
                System.out.println("[LOGIN RESULT] 读者登录成功");
                System.out.println("redirect target = /reader/v2/home");
                System.out.println("========== [LOGIN DEBUG END] ==========");
                System.out.println();
                return "redirect:/reader/v2/home?success=登录成功";
            }
        }

        model.addAttribute("error", "账号、密码或用户身份错误");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);
        logLogin(request, "UNKNOWN", null, loginName, "登录失败：账号、密码或身份错误");

        System.out.println("[LOGIN RESULT] 登录失败");
        System.out.println("return view = login");
        System.out.println("========== [LOGIN DEBUG END] ==========");
        System.out.println();
        return "login";
    }

    private Admin tryAdminLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        Admin admin = adminService.login(username, rawPassword);
        if (admin != null) {
            return admin;
        }
        admin = adminService.login(username, md5Lower);
        if (admin != null) {
            return admin;
        }
        return adminService.login(username, md5Upper);
    }

    private Reader tryReaderLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        Reader reader = readerService.login(username, rawPassword);
        if (reader != null) {
            return reader;
        }
        reader = readerService.login(username, md5Lower);
        if (reader != null) {
            return reader;
        }
        return readerService.login(username, md5Upper);
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletRequest request) {
        String userType = session == null ? "UNKNOWN" : String.valueOf(session.getAttribute("userType"));
        Object loginUser = session == null ? null : session.getAttribute("loginUser");
        String operatorName = loginUser == null ? "未知用户" : String.valueOf(loginUser);
        logLogin(request, userType, null, operatorName, "退出登录");
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login?success=已退出登录";
    }

    private void logLogin(HttpServletRequest request, String operatorType, Integer operatorId, String operatorName, String operation) {
        v2BusinessService.logOperation(operatorType, operatorId, operatorName, "登录认证", operation, request.getRequestURI(), request.getRemoteAddr());
    }
}

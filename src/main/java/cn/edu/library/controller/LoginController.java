package cn.edu.library.controller;

import cn.edu.library.entity.Admin;
import cn.edu.library.entity.Reader;
import cn.edu.library.service.AdminService;
import cn.edu.library.service.ReaderService;
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
 * 登录控制器
 */
@Controller
public class LoginController {

    @Resource
    private AdminService adminService;

    @Resource
    private ReaderService readerService;

    /**
     * 【本次修改】登录页入口。
     */
    @GetMapping({"/login", "/"})
    public String loginPage(HttpServletRequest request) {
        System.out.println("========== [LOGIN PAGE] ==========");
        System.out.println("GET login page");
        System.out.println("requestURI = " + request.getRequestURI());
        System.out.println("contextPath = " + request.getContextPath());
        System.out.println("==================================");
        return "login";
    }

    /**
     * 【本次修改】登录成功后统一写入 userType + loginRole。
     *
     * 修复点：
     * 1. LoginInterceptor 旧逻辑会读取 loginRole。
     * 2. v2 新逻辑会读取 userType。
     * 3. 两个字段同时写入，避免登录成功后又被拦截器踢回 /login。
     */
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam String userType,
                        Model model,
                        HttpSession session,
                        HttpServletRequest request) {

        String loginName = username == null ? "" : username.trim();
        String rawPassword = password == null ? "" : password.trim();
        String loginType = userType == null ? "" : userType.trim().toLowerCase();

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
            System.out.println("[LOGIN STEP] 当前选择身份：管理员");
            Admin admin = tryAdminLogin(loginName, rawPassword, md5Lower, md5Upper);

            if (admin != null) {
                session.setAttribute("loginUser", admin);
                session.setAttribute("userType", "ADMIN");
                session.setAttribute("loginRole", "ADMIN");
                session.setAttribute("adminRole", admin.getRole());

                System.out.println("[LOGIN RESULT] 管理员登录成功");
                System.out.println("admin.username = " + admin.getUsername());
                System.out.println("admin.role = " + admin.getRole());
                System.out.println("session userType = " + session.getAttribute("userType"));
                System.out.println("session loginRole = " + session.getAttribute("loginRole"));
                System.out.println("session adminRole = " + session.getAttribute("adminRole"));
                System.out.println("redirect target = /admin/v2/dashboard");
                System.out.println("========== [LOGIN DEBUG END] ==========");
                System.out.println();

                return "redirect:/admin/v2/dashboard";
            }

            System.out.println("[LOGIN RESULT] 管理员登录失败，adminService.login 查询不到账号");
        }

        if ("reader".equals(loginType)) {
            System.out.println("[LOGIN STEP] 当前选择身份：读者");
            Reader reader = tryReaderLogin(loginName, rawPassword, md5Lower, md5Upper);

            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");
                session.setAttribute("loginRole", "READER");

                System.out.println("[LOGIN RESULT] 读者登录成功");
                System.out.println("reader.username = " + reader.getUsername());
                System.out.println("reader.name = " + reader.getName());
                System.out.println("session userType = " + session.getAttribute("userType"));
                System.out.println("session loginRole = " + session.getAttribute("loginRole"));
                System.out.println("redirect target = /reader/v2/home");
                System.out.println("========== [LOGIN DEBUG END] ==========");
                System.out.println();

                return "redirect:/reader/v2/home";
            }

            System.out.println("[LOGIN RESULT] 读者登录失败，readerService.login 查询不到账号");
        }

        if (!"admin".equals(loginType) && !"reader".equals(loginType)) {
            System.out.println("[LOGIN RESULT] 登录失败，userType 非法：" + loginType);
        }

        model.addAttribute("error", "账号、密码或用户身份错误");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);

        System.out.println("return view = login");
        System.out.println("========== [LOGIN DEBUG END] ==========");
        System.out.println();
        return "login";
    }

    /**
     * 【本次修改】管理员登录尝试：兼容明文、MD5 小写、MD5 大写。
     */
    private Admin tryAdminLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        System.out.println("[ADMIN LOGIN TRY] password type = raw");
        Admin admin = adminService.login(username, rawPassword);
        if (admin != null) {
            System.out.println("[ADMIN LOGIN HIT] raw password matched");
            return admin;
        }

        System.out.println("[ADMIN LOGIN TRY] password type = md5 lower");
        admin = adminService.login(username, md5Lower);
        if (admin != null) {
            System.out.println("[ADMIN LOGIN HIT] md5 lower matched");
            return admin;
        }

        System.out.println("[ADMIN LOGIN TRY] password type = md5 upper");
        admin = adminService.login(username, md5Upper);
        if (admin != null) {
            System.out.println("[ADMIN LOGIN HIT] md5 upper matched");
            return admin;
        }

        System.out.println("[ADMIN LOGIN MISS] all password types failed");
        return null;
    }

    /**
     * 【本次修改】读者登录尝试：兼容明文、MD5 小写、MD5 大写。
     */
    private Reader tryReaderLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        System.out.println("[READER LOGIN TRY] password type = raw");
        Reader reader = readerService.login(username, rawPassword);
        if (reader != null) {
            System.out.println("[READER LOGIN HIT] raw password matched");
            return reader;
        }

        System.out.println("[READER LOGIN TRY] password type = md5 lower");
        reader = readerService.login(username, md5Lower);
        if (reader != null) {
            System.out.println("[READER LOGIN HIT] md5 lower matched");
            return reader;
        }

        System.out.println("[READER LOGIN TRY] password type = md5 upper");
        reader = readerService.login(username, md5Upper);
        if (reader != null) {
            System.out.println("[READER LOGIN HIT] md5 upper matched");
            return reader;
        }

        System.out.println("[READER LOGIN MISS] all password types failed");
        return null;
    }

    /**
     * 【本次修改】退出登录。
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        System.out.println("========== [LOGOUT] ==========");
        System.out.println("sessionId = " + session.getId());
        session.invalidate();
        System.out.println("redirect target = /login");
        System.out.println("==============================");
        return "redirect:/login";
    }
}

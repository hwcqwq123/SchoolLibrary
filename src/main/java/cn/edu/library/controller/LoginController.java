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
 * 【本次修改】登录控制器。
 *
 * 管理员角色跳转规则：
 * 1. SUPER_ADMIN 固定唯一账号 admin，登录后进入普通管理员管理页。
 * 2. ADMIN 普通管理员，登录后进入业务首页。
 */
@Controller
public class LoginController {

    @Resource
    private AdminService adminService;

    @Resource
    private ReaderService readerService;

    @GetMapping({"/login", "/"})
    public String loginPage() {
        return "login";
    }

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

        if ("admin".equals(loginType)) {
            Admin admin = tryAdminLogin(loginName, rawPassword, md5Lower, md5Upper);
            if (admin != null) {
                session.setAttribute("loginUser", admin);
                session.setAttribute("userType", "ADMIN");
                session.setAttribute("loginRole", "ADMIN");
                session.setAttribute("adminRole", admin.getRole());

                if ("SUPER_ADMIN".equals(admin.getRole())) {
                    return "redirect:/admin/v2/admins";
                }
                return "redirect:/admin/v2/dashboard";
            }
        }

        if ("reader".equals(loginType)) {
            Reader reader = tryReaderLogin(loginName, rawPassword, md5Lower, md5Upper);
            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");
                session.setAttribute("loginRole", "READER");
                return "redirect:/reader/v2/home";
            }
        }

        model.addAttribute("error", "账号、密码或用户身份错误");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);
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
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}

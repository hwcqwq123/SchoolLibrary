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
    public String loginPage() {
        return "login";
    }

    /**
     * 【本次修改】登录成功后统一进入 v2 完整功能首页。
     */
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam String userType,
                        Model model,
                        HttpSession session) {

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
                session.setAttribute("adminRole", admin.getRole());
                return "redirect:/admin/v2/dashboard";
            }
        }

        if ("reader".equals(loginType)) {
            Reader reader = tryReaderLogin(loginName, rawPassword, md5Lower, md5Upper);
            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");
                return "redirect:/reader/v2/home";
            }
        }

        model.addAttribute("error", "账号、密码或用户身份错误");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);
        return "login";
    }

    /** 【本次修改】兼容明文、MD5 小写、MD5 大写。 */
    private Admin tryAdminLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        Admin admin = adminService.login(username, rawPassword);
        if (admin != null) return admin;
        admin = adminService.login(username, md5Lower);
        if (admin != null) return admin;
        return adminService.login(username, md5Upper);
    }

    /** 【本次修改】兼容明文、MD5 小写、MD5 大写。 */
    private Reader tryReaderLogin(String username, String rawPassword, String md5Lower, String md5Upper) {
        Reader reader = readerService.login(username, rawPassword);
        if (reader != null) return reader;
        reader = readerService.login(username, md5Lower);
        if (reader != null) return reader;
        return readerService.login(username, md5Upper);
    }

    /** 【本次修改】退出登录。 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}

package cn.edu.library.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import cn.edu.library.entity.Admin;
import cn.edu.library.entity.Reader;
import cn.edu.library.service.AdminService;
import cn.edu.library.service.ReaderService;
import cn.edu.library.util.Md5Util;

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
     * 登录页入口
     */
    @GetMapping({"/login", "/"})
    public String loginPage() {
        return "login";
    }

    /**
     * 【本次修改】
     * 登录逻辑已验证成功。
     *
     * 本次重点修改：
     * 1. 删除临时 LOGIN DEBUG 控制台输出。
     * 2. 管理员登录成功后跳转到 /admin/books。
     * 3. 避免继续跳转到可能不存在的 /admin/dashboard。
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

                /*
                 * 【本次修改】
                 * 原来可能是 redirect:/admin/dashboard。
                 * 如果项目里暂时没有 /admin/dashboard，就会登录成功后 404。
                 * 现在改成已经稳定存在的管理员图书管理页。
                 */
                return "redirect:/admin/books";
            }
        }

        if ("reader".equals(loginType)) {
            Reader reader = tryReaderLogin(loginName, rawPassword, md5Lower, md5Upper);

            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");

                /*
                 * 【本次修改】
                 * 如果你的读者首页 /reader/home 不存在，
                 * 后面再根据实际 Controller 改成对应读者图书查询页。
                 */
                return "redirect:/reader/home";
            }
        }

        model.addAttribute("error", "账号、密码或用户身份错误");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);

        return "login";
    }

    /**
     * 【本次修改】管理员登录尝试
     * 兼容明文、MD5 小写、MD5 大写三种情况。
     */
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

    /**
     * 【本次修改】读者登录尝试
     * 兼容明文、MD5 小写、MD5 大写三种情况。
     */
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

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
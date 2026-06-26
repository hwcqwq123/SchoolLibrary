package cn.edu.library.controller;

import cn.edu.library.entity.Admin;
import cn.edu.library.entity.Reader;
import cn.edu.library.service.AdminService;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * 登录控制器：处理管理员和读者的登录、退出。
 */
@Controller
public class LoginController {
    @Resource
    private AdminService adminService;
    @Resource
    private ReaderService readerService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam String role,
                        HttpSession session,
                        Model model) {
        if ("ADMIN".equals(role)) {
            Admin admin = adminService.login(username, password);
            if (admin != null) {
                session.setAttribute("loginUser", admin);
                session.setAttribute("loginRole", "ADMIN");
                session.setAttribute("loginName", admin.getRealName());
                return "redirect:/admin/dashboard";
            }
        } else if ("READER".equals(role)) {
            Reader reader = readerService.login(username, password);
            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("loginRole", "READER");
                session.setAttribute("loginName", reader.getName());
                return "redirect:/reader/home";
            }
        }
        model.addAttribute("error", "账号、密码或身份选择错误");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}

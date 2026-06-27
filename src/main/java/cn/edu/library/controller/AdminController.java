package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 管理员首页控制器。
 *
 * 【本次修改】
 * 旧版 /admin/dashboard 不再返回旧 JSP，统一跳转到新版 v2 首页，避免页面风格混乱。
 */
@Controller
public class AdminController {

    @GetMapping("/admin/dashboard")
    public String dashboard() {
        return "redirect:/admin/v2/dashboard";
    }
}

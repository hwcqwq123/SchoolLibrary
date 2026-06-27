package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 【本次修改】旧管理员 Controller 封存为 v2 路由跳转。
 *
 * 原旧页面会返回 admin/dashboard.jsp，导致用户误跳回旧布局。
 * 现在统一跳转到 v2 页面。
 */
@Controller
public class AdminController {

    @GetMapping("/admin/dashboard")
    public String dashboard() {
        return "redirect:/admin/v2/dashboard";
    }
}

package cn.edu.library.controller;

import cn.edu.library.service.StatisticsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import javax.annotation.Resource;

/** 管理员首页控制器。 */
@Controller
public class AdminController {
    @Resource
    private StatisticsService statisticsService;

    @GetMapping("/admin/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("stats", statisticsService.dashboard());
        return "admin/dashboard";
    }
}

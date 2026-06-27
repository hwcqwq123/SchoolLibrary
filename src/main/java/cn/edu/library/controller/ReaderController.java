package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 【本次修改】旧读者 Controller 封存为 v2 路由跳转。
 */
@Controller
public class ReaderController {

    @RequestMapping(value = "/admin/readers", method = {RequestMethod.GET, RequestMethod.POST})
    public String adminReaders() {
        return "redirect:/admin/v2/readers";
    }

    @RequestMapping(value = {"/admin/reader/add", "/admin/reader/edit", "/admin/reader/delete"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String adminReaderActions() {
        return "redirect:/admin/v2/readers?error=旧版读者编辑入口已封存，请在新版 v2 读者管理中操作";
    }

    @RequestMapping(value = "/reader/home", method = {RequestMethod.GET, RequestMethod.POST})
    public String readerHome() {
        return "redirect:/reader/v2/home";
    }

    @RequestMapping(value = "/reader/password", method = {RequestMethod.GET, RequestMethod.POST})
    public String readerPassword() {
        return "redirect:/reader/v2/profile?error=密码修改入口已合并到新版个人中心";
    }
}

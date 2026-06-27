package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 【本次修改】旧借阅 Controller 封存为 v2 路由跳转。
 *
 * 说明：
 * 旧 JSP 页面仍在项目历史中，但不再由 Controller 返回，避免跳回旧布局。
 */
@Controller
public class BorrowController {

    @RequestMapping(value = "/admin/borrow/list", method = {RequestMethod.GET, RequestMethod.POST})
    public String list() {
        return "redirect:/admin/v2/borrows";
    }

    @RequestMapping(value = {"/admin/borrow/add", "/admin/borrow/return"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String borrowActions() {
        return "redirect:/admin/v2/borrows?error=旧版借阅操作入口已封存，请使用新版借阅管理流程";
    }

    @RequestMapping(value = "/reader/borrows", method = {RequestMethod.GET, RequestMethod.POST})
    public String myBorrows() {
        return "redirect:/reader/v2/borrows";
    }
}

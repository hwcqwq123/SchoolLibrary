package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 【本次修改】旧图书 Controller 封存为 v2 路由跳转。
 *
 * 目的：
 * 1. 避免 /admin/books、/reader/books 继续展示旧 JSP 布局。
 * 2. 统一图书相关入口到 v2 页面。
 */
@Controller
public class BookController {

    @RequestMapping(value = "/admin/books", method = {RequestMethod.GET, RequestMethod.POST})
    public String adminBooks() {
        return "redirect:/admin/v2/books";
    }

    @RequestMapping(value = {"/admin/book/add", "/admin/book/edit", "/admin/book/delete"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String adminBookActions() {
        return "redirect:/admin/v2/books?error=旧版图书编辑入口已封存，请在新版 v2 图书管理中操作";
    }

    @RequestMapping(value = "/reader/books", method = {RequestMethod.GET, RequestMethod.POST})
    public String readerBooks() {
        return "redirect:/reader/v2/books";
    }
}

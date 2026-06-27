package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 【本次新增】旧路径兼容与 v2 路由统一控制器
 *
 * 作用：
 * 1. 旧页面菜单里如果还有 /admin/xxx 或 /reader/xxx，不再 404。
 * 2. 尽量把旧入口统一导向 /admin/v2/** 和 /reader/v2/**。
 * 3. 避免用户感觉“点着点着又回到旧页面”。
 */
@Controller
public class RouteCompatController {

    /** 【本次新增】管理员首页旧入口统一到 v2 首页。 */
    @GetMapping({"/admin", "/admin/", "/admin/dashboard", "/admin/home"})
    public String adminHome() {
        return "redirect:/admin/v2/dashboard";
    }

    /** 【本次新增】旧分类入口统一到 v2 分类管理。 */
    @GetMapping({"/admin/categories", "/admin/category"})
    public String adminCategories() {
        return "redirect:/admin/v2/categories";
    }

    /** 【本次新增】旧公告入口统一到 v2 公告管理。 */
    @GetMapping({"/admin/notices", "/admin/notice"})
    public String adminNotices() {
        return "redirect:/admin/v2/notices";
    }

    /** 【本次新增】旧借阅入口统一到 v2 借阅概览。 */
    @GetMapping({"/admin/borrows", "/admin/borrow", "/admin/borrow-records", "/admin/v2/borrow-records"})
    public String adminBorrows() {
        return "redirect:/admin/v2/borrows";
    }

    /** 【本次新增】旧续借入口统一到 v2 续借审核。 */
    @GetMapping({"/admin/renews", "/admin/renew", "/admin/renew-requests", "/admin/v2/renew-requests"})
    public String adminRenews() {
        return "redirect:/admin/v2/renews";
    }

    /** 【本次新增】旧罚款入口统一到 v2 罚款管理。 */
    @GetMapping({"/admin/fines", "/admin/fine"})
    public String adminFines() {
        return "redirect:/admin/v2/fines";
    }

    /** 【本次新增】旧座位入口统一到 v2 座位管理。 */
    @GetMapping({"/admin/seats", "/admin/seat", "/admin/seat-reservations"})
    public String adminSeats() {
        return "redirect:/admin/v2/seats";
    }

    /** 【本次新增】旧数据维护入口统一到 v2 数据维护。 */
    @GetMapping({"/admin/data", "/admin/export", "/admin/import"})
    public String adminData() {
        return "redirect:/admin/v2/data";
    }

    /** 【本次新增】系统管理、管理员管理、日志管理都统一到 v2 system 页面。 */
    @GetMapping({"/admin/system", "/admin/admins", "/admin/logs", "/admin/v2/admins", "/admin/v2/logs"})
    public String adminSystem() {
        return "redirect:/admin/v2/system";
    }

    /** 【本次新增】旧图书入口导向 v2 图书概览页。 */
    @GetMapping({"/admin/books", "/admin/book"})
    public String adminBooks() {
        return "redirect:/admin/v2/books";
    }

    /** 【本次新增】旧读者入口导向 v2 读者概览页。 */
    @GetMapping({"/admin/readers", "/admin/reader"})
    public String adminReaders() {
        return "redirect:/admin/v2/readers";
    }

    /** 【本次新增】读者旧首页入口统一到 v2 首页。 */
    @GetMapping({"/reader", "/reader/", "/reader/home"})
    public String readerHome() {
        return "redirect:/reader/v2/home";
    }

    /** 【本次新增】读者旧图书入口统一到 v2 图书查询。 */
    @GetMapping({"/reader/books", "/reader/book-search", "/reader/search"})
    public String readerBooks() {
        return "redirect:/reader/v2/books";
    }

    /** 【本次新增】读者旧借阅入口统一到 v2 我的借阅。 */
    @GetMapping({"/reader/borrows", "/reader/my-borrows", "/reader/borrow-records"})
    public String readerBorrows() {
        return "redirect:/reader/v2/borrows";
    }

    /** 【本次新增】读者旧座位入口统一到 v2 座位预约。 */
    @GetMapping({"/reader/seats", "/reader/seat", "/reader/seat-reservations"})
    public String readerSeats() {
        return "redirect:/reader/v2/seats";
    }

    /** 【本次新增】读者旧个人中心入口统一到 v2 个人中心。 */
    @GetMapping({"/reader/profile", "/reader/person", "/reader/center"})
    public String readerProfile() {
        return "redirect:/reader/v2/profile";
    }
}

package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 【本次修改】非冲突旧路径兼容跳转控制器。
 *
 * 注意：
 * 这里不再映射 /admin/books、/admin/readers、/reader/books、/reader/borrows 等
 * 已经由旧 Controller 接管并跳转的路径，避免 Spring Ambiguous mapping。
 */
@Controller
public class RouteCompatController {

    @GetMapping({"/admin", "/admin/"})
    public String adminRoot() {
        return "redirect:/admin/v2/dashboard";
    }

    @GetMapping({"/admin/categories", "/admin/category"})
    public String adminCategories() {
        return "redirect:/admin/v2/categories";
    }

    @GetMapping({"/admin/notices", "/admin/notice"})
    public String adminNotices() {
        return "redirect:/admin/v2/notices";
    }

    @GetMapping({"/admin/borrows", "/admin/borrow-records", "/admin/v2/borrow-records"})
    public String adminBorrows() {
        return "redirect:/admin/v2/borrows";
    }

    @GetMapping({"/admin/renews", "/admin/renew", "/admin/renew-requests", "/admin/v2/renew-requests"})
    public String adminRenews() {
        return "redirect:/admin/v2/renews";
    }

    @GetMapping({"/admin/fines", "/admin/fine"})
    public String adminFines() {
        return "redirect:/admin/v2/fines";
    }

    @GetMapping({"/admin/seats", "/admin/seat", "/admin/seat-reservations"})
    public String adminSeats() {
        return "redirect:/admin/v2/seats";
    }

    @GetMapping({"/admin/data", "/admin/export", "/admin/import"})
    public String adminData() {
        return "redirect:/admin/v2/data";
    }

    @GetMapping({"/admin/system", "/admin/admins", "/admin/logs"})
    public String adminSystem() {
        return "redirect:/admin/v2/admins";
    }

    @GetMapping({"/reader", "/reader/"})
    public String readerRoot() {
        return "redirect:/reader/v2/home";
    }

    @GetMapping({"/reader/book-search", "/reader/search"})
    public String readerBookSearch() {
        return "redirect:/reader/v2/books";
    }

    @GetMapping({"/reader/my-borrows", "/reader/borrow-records"})
    public String readerBorrowRecords() {
        return "redirect:/reader/v2/borrows";
    }

    @GetMapping({"/reader/seats", "/reader/seat", "/reader/seat-reservations"})
    public String readerSeats() {
        return "redirect:/reader/v2/seats";
    }

    @GetMapping({"/reader/profile", "/reader/person", "/reader/center"})
    public String readerProfile() {
        return "redirect:/reader/v2/profile";
    }
}

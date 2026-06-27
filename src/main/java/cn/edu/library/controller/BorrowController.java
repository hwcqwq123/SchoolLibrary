package cn.edu.library.controller;

import cn.edu.library.entity.Reader;
import cn.edu.library.service.BookService;
import cn.edu.library.service.BorrowService;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * 借阅归还控制器。
 *
 * 【本次修改】
 * 旧列表入口统一跳转到 v2 借阅概览，避免点击菜单回到旧布局。
 */
@Controller
public class BorrowController {

    @Resource
    private BorrowService borrowService;

    @Resource
    private ReaderService readerService;

    @Resource
    private BookService bookService;

    @GetMapping("/admin/borrow/list")
    public String list() {
        return "redirect:/admin/v2/borrows";
    }

    @GetMapping("/admin/borrow/add")
    public String addPage(Model model) {
        model.addAttribute("readers", readerService.search(null));
        model.addAttribute("books", bookService.search(null, null));
        return "admin/borrow-form";
    }

    @PostMapping("/admin/borrow/add")
    public String add(@RequestParam Integer readerId,
                      @RequestParam Integer bookId,
                      @RequestParam Integer borrowDays,
                      Model model) {
        try {
            borrowService.borrowBook(readerId, bookId, borrowDays);
            return "redirect:/admin/v2/borrows";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("readers", readerService.search(null));
            model.addAttribute("books", bookService.search(null, null));
            return "admin/borrow-form";
        }
    }

    @GetMapping("/admin/borrow/return")
    public String returnBook(@RequestParam Integer id) {
        borrowService.returnBook(id);
        return "redirect:/admin/v2/borrows";
    }

    @GetMapping("/reader/borrows")
    public String myBorrows(HttpSession session) {
        return "redirect:/reader/v2/borrows";
    }
}

package cn.edu.library.controller;

import cn.edu.library.entity.Reader;
import cn.edu.library.service.BookService;
import cn.edu.library.service.BorrowService;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * 借阅归还控制器：实现管理员借书、还书、借阅记录查询，以及读者查看个人借阅。
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
    public String list(@RequestParam(required = false) String keyword,
                       @RequestParam(required = false) String status,
                       Model model) {
        model.addAttribute("records", borrowService.search(keyword, status));
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        return "admin/borrow-list";
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
            return "redirect:/admin/borrow/list";
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
        return "redirect:/admin/borrow/list";
    }

    @GetMapping("/reader/borrows")
    public String myBorrows(HttpSession session, Model model) {
        Reader reader = (Reader) session.getAttribute("loginUser");
        model.addAttribute("records", borrowService.findByReaderId(reader.getId()));
        return "reader/my-borrows";
    }
}

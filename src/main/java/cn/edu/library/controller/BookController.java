package cn.edu.library.controller;

import cn.edu.library.entity.Book;
import cn.edu.library.service.BookService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

/**
 * 图书管理控制器：对应管理员端图书新增、修改、删除、查询，以及读者端图书查询。
 */
@Controller
public class BookController {
    @Resource
    private BookService bookService;

    @GetMapping("/admin/books")
    public String adminBooks(@RequestParam(required = false) String keyword,
                             @RequestParam(required = false) String category,
                             Model model) {
        model.addAttribute("books", bookService.search(keyword, category));
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        return "admin/book-list";
    }

    @GetMapping("/admin/book/add")
    public String addPage(Model model) {
        model.addAttribute("book", new Book());
        model.addAttribute("action", "add");
        return "admin/book-form";
    }

    @PostMapping("/admin/book/add")
    public String add(Book book) {
        bookService.save(book);
        return "redirect:/admin/books";
    }

    @GetMapping("/admin/book/edit")
    public String editPage(@RequestParam Integer id, Model model) {
        model.addAttribute("book", bookService.findById(id));
        model.addAttribute("action", "edit");
        return "admin/book-form";
    }

    @PostMapping("/admin/book/edit")
    public String edit(Book book) {
        bookService.update(book);
        return "redirect:/admin/books";
    }

    @GetMapping("/admin/book/delete")
    public String delete(@RequestParam Integer id) {
        bookService.delete(id);
        return "redirect:/admin/books";
    }

    @GetMapping("/reader/books")
    public String readerBooks(@RequestParam(required = false) String keyword,
                              @RequestParam(required = false) String category,
                              Model model) {
        model.addAttribute("books", bookService.search(keyword, category));
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        return "reader/book-search";
    }
}

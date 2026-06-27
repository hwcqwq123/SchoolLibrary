package cn.edu.library.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest; // 【本次修改】新增：引入上传工具类

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // 【本次修改】新增：接收上传文件
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile; // 【本次修改】新增：用于获取 webapp 上传目录

import cn.edu.library.entity.Book;
import cn.edu.library.service.BookService;
import cn.edu.library.util.UploadUtil;

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

    /**
     * 【本次修改】新增图书时支持上传图书封面
     */
    @PostMapping("/admin/book/add")
    public String add(Book book,
                      @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                      HttpServletRequest request) throws IOException {

        String coverImage = UploadUtil.saveImage(coverFile, request, "book");
        if (coverImage != null) {
            book.setCoverImage(coverImage);
        }

        bookService.save(book);
        return "redirect:/admin/books";
    }

    @GetMapping("/admin/book/edit")
    public String editPage(@RequestParam Integer id, Model model) {
        model.addAttribute("book", bookService.findById(id));
        model.addAttribute("action", "edit");
        return "admin/book-form";
    }

    /**
     * 【本次修改】修改图书时支持重新上传图书封面
     * 如果没有重新上传，则保留原来的封面。
     */
    @PostMapping("/admin/book/edit")
    public String edit(Book book,
                       @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                       HttpServletRequest request) throws IOException {

        Book oldBook = bookService.findById(book.getId());

        String coverImage = UploadUtil.saveImage(coverFile, request, "book");
        if (coverImage != null) {
            book.setCoverImage(coverImage);
        } else if (oldBook != null) {
            book.setCoverImage(oldBook.getCoverImage());
        }

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
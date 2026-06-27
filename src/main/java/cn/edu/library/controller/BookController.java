package cn.edu.library.controller;

import cn.edu.library.entity.Book;
import cn.edu.library.service.BookService;
import cn.edu.library.util.UploadUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLEncoder;

/**
 * 图书管理控制器。
 *
 * 【本次修改】
 * 1. /admin/books 不再返回旧版 admin/book-list.jsp，统一跳转 /admin/v2/books。
 * 2. /reader/books 不再返回旧版 reader/book-search.jsp，统一跳转 /reader/v2/books。
 * 3. 新增、修改、删除完成后回到 v2 图书管理页。
 */
@Controller
public class BookController {

    @Resource
    private BookService bookService;

    @GetMapping("/admin/books")
    public String adminBooks(@RequestParam(required = false) String keyword) throws Exception {
        return "redirect:/admin/v2/books" + query("keyword", keyword);
    }

    @GetMapping("/admin/book/add")
    public String addPage(Model model) {
        model.addAttribute("book", new Book());
        model.addAttribute("action", "add");
        return "admin/book-form";
    }

    @PostMapping("/admin/book/add")
    public String add(Book book,
                      @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                      HttpServletRequest request) throws IOException {
        String coverImage = UploadUtil.saveImage(coverFile, request, "book");
        if (coverImage != null) {
            book.setCoverImage(coverImage);
        }
        bookService.save(book);
        return "redirect:/admin/v2/books";
    }

    @GetMapping("/admin/book/edit")
    public String editPage(@RequestParam Integer id, Model model) {
        model.addAttribute("book", bookService.findById(id));
        model.addAttribute("action", "edit");
        return "admin/book-form";
    }

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
        return "redirect:/admin/v2/books";
    }

    @GetMapping("/admin/book/delete")
    public String delete(@RequestParam Integer id) {
        bookService.delete(id);
        return "redirect:/admin/v2/books";
    }

    @GetMapping("/reader/books")
    public String readerBooks(@RequestParam(required = false) String keyword) throws Exception {
        return "redirect:/reader/v2/books" + query("keyword", keyword);
    }

    private String query(String key, String value) throws Exception {
        if (value == null || value.trim().isEmpty()) {
            return "";
        }
        return "?" + key + "=" + URLEncoder.encode(value.trim(), "UTF-8");
    }
}

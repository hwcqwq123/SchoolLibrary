package cn.edu.library.controller;

import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.mapper.V2Mapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;

/**
 * 【本次新增】管理员端 v2 补充页面控制器
 *
 * 作用：
 * 1. 补齐 /admin/v2/books，避免从新版首页跳到旧版 /admin/books。
 * 2. 补齐 /admin/v2/readers，避免从新版首页跳到旧版 /admin/readers。
 * 3. 补齐 /admin/v2/borrows，避免旧链接 /admin/borrows 404。
 * 4. /admin/v2/admins、/admin/v2/logs 统一转到已有 /admin/v2/system。
 */
@Controller
@RequestMapping("/admin/v2")
public class V2AdminExtraController {

    @Resource
    private V2Mapper v2Mapper;

    @Resource
    private ReaderMapper readerMapper;

    /**
     * 【本次新增】v2 图书概览页。
     */
    @GetMapping("/books")
    public String books(@RequestParam(required = false) String keyword,
                        @RequestParam(required = false) Integer categoryId,
                        Model model) {
        model.addAttribute("books", v2Mapper.searchBooks(keyword, categoryId, null));
        model.addAttribute("categories", v2Mapper.listCategories(null));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        return "admin/v2-books";
    }

    /**
     * 【本次新增】v2 读者概览页。
     */
    @GetMapping("/readers")
    public String readers(@RequestParam(required = false) String keyword,
                          Model model) {
        model.addAttribute("readers", readerMapper.search(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-readers";
    }

    /**
     * 【本次新增】v2 借阅概览页。
     */
    @GetMapping("/borrows")
    public String borrows(Model model) {
        model.addAttribute("recentBorrows", v2Mapper.recentBorrows(100));
        model.addAttribute("overdueList", v2Mapper.overdueList());
        return "admin/v2-borrows";
    }

    /**
     * 【本次新增】管理员管理归入系统管理页。
     */
    @GetMapping("/admins")
    public String admins() {
        return "redirect:/admin/v2/system";
    }

    /**
     * 【本次新增】操作日志归入系统管理页。
     */
    @GetMapping("/logs")
    public String logs() {
        return "redirect:/admin/v2/system";
    }
}

package cn.edu.library.controller;

import cn.edu.library.entity.Reader;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/** 读者管理控制器。 */
@Controller
public class ReaderController {
    @Resource
    private ReaderService readerService;

    @GetMapping("/admin/readers")
    public String list(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("readers", readerService.search(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/reader-list";
    }

    @GetMapping("/admin/reader/add")
    public String addPage(Model model) {
        model.addAttribute("reader", new Reader());
        model.addAttribute("action", "add");
        return "admin/reader-form";
    }

    @PostMapping("/admin/reader/add")
    public String add(Reader reader) {
        readerService.save(reader);
        return "redirect:/admin/readers";
    }

    @GetMapping("/admin/reader/edit")
    public String editPage(@RequestParam Integer id, Model model) {
        model.addAttribute("reader", readerService.findById(id));
        model.addAttribute("action", "edit");
        return "admin/reader-form";
    }

    @PostMapping("/admin/reader/edit")
    public String edit(Reader reader) {
        readerService.update(reader);
        return "redirect:/admin/readers";
    }

    @GetMapping("/admin/reader/delete")
    public String delete(@RequestParam Integer id) {
        readerService.disable(id);
        return "redirect:/admin/readers";
    }

    @GetMapping("/reader/home")
    public String readerHome() {
        return "reader/home";
    }

    @GetMapping("/reader/password")
    public String passwordPage() {
        return "reader/password";
    }

    @PostMapping("/reader/password")
    public String changePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 Model model) {
        Reader reader = (Reader) session.getAttribute("loginUser");
        boolean success = readerService.changePassword(reader.getId(), oldPassword, newPassword);
        model.addAttribute(success ? "message" : "error", success ? "密码修改成功" : "旧密码错误，修改失败");
        return "reader/password";
    }
}

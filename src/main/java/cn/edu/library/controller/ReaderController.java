package cn.edu.library.controller;

import cn.edu.library.entity.Reader;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;

/**
 * 读者管理控制器。
 *
 * 【本次修改】
 * 旧入口统一跳转到 v2，避免进入旧版简陋布局。
 */
@Controller
public class ReaderController {

    @Resource
    private ReaderService readerService;

    @GetMapping("/admin/readers")
    public String list(@RequestParam(required = false) String keyword) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/admin/v2/readers";
        }
        return "redirect:/admin/v2/readers?keyword=" + URLEncoder.encode(keyword.trim(), "UTF-8");
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
        return "redirect:/admin/v2/readers";
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
        return "redirect:/admin/v2/readers";
    }

    @GetMapping("/admin/reader/delete")
    public String delete(@RequestParam Integer id) {
        readerService.disable(id);
        return "redirect:/admin/v2/readers";
    }

    @GetMapping("/reader/home")
    public String readerHome() {
        return "redirect:/reader/v2/home";
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

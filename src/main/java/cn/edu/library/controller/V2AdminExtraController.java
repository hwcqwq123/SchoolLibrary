package cn.edu.library.controller;

import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.mapper.V2BorrowAdminMapper;
import cn.edu.library.mapper.V2Mapper;
import cn.edu.library.service.V2BorrowBusinessService;
import cn.edu.library.util.V2AdminRoleUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 【本次修改】管理员端 v2 补充页面控制器。
 *
 * 本次职责调整：
 * 1. SUPER_ADMIN 是“管理员的管理员”，不进入读者、图书、借阅等业务页面。
 * 2. ADMIN 是业务管理员，负责读者、图书、借阅、罚款、座位等日常业务。
 * 3. /admin/v2/borrows 从“借阅概览”升级为“借阅业务办理页”。
 */
@Controller
@RequestMapping("/admin/v2")
public class V2AdminExtraController {

    @Resource
    private V2Mapper v2Mapper;

    @Resource
    private ReaderMapper readerMapper;

    @Resource
    private V2BorrowAdminMapper borrowAdminMapper;

    @Resource
    private V2BorrowBusinessService borrowBusinessService;

    @GetMapping("/books")
    public String books(@RequestParam(required = false) String keyword,
                        @RequestParam(required = false) Integer categoryId,
                        HttpSession session,
                        Model model,
                        RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForSuperAdmin());
            return "redirect:/admin/v2/admins";
        }
        model.addAttribute("books", v2Mapper.searchBooks(keyword, categoryId, null));
        model.addAttribute("categories", v2Mapper.listCategories(null));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        return "admin/v2-books";
    }

    @GetMapping("/readers")
    public String readers(@RequestParam(required = false) String keyword,
                          HttpSession session,
                          Model model,
                          RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", "超级管理员不管理读者账号。读者相关业务由普通管理员负责。 ");
            return "redirect:/admin/v2/admins";
        }
        model.addAttribute("readers", readerMapper.search(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-readers";
    }

    @GetMapping("/borrows")
    public String borrows(HttpSession session,
                          HttpServletRequest request,
                          Model model,
                          RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", "超级管理员不参与日常借阅业务。借书、还书、上架由普通管理员办理。 ");
            return "redirect:/admin/v2/admins";
        }
        Admin admin = V2AdminRoleUtil.currentAdmin(session);
        int autoShelfCount = borrowBusinessService.autoShelfExpiredCopies(admin, request);
        model.addAttribute("autoShelfCount", autoShelfCount);
        model.addAttribute("recentBorrows", borrowAdminMapper.listRecentBorrowRecords(100));
        model.addAttribute("overdueList", borrowAdminMapper.listOverdueBorrowRecords());
        model.addAttribute("processingCopies", borrowAdminMapper.listReturnProcessingCopies());
        return "admin/v2-borrows";
    }
}

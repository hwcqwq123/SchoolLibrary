package cn.edu.library.controller;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.entity.Admin;
import cn.edu.library.service.V2BorrowBusinessService;
import cn.edu.library.util.V2AdminRoleUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 【本次新增】v2 借阅办理动作控制器。
 */
@Controller
@RequestMapping("/admin/v2/borrows")
public class V2BorrowAdminController {

    @Resource
    private V2BorrowBusinessService borrowBusinessService;

    @PostMapping("/borrow")
    public String borrow(@RequestParam(required = false) String readerKey,
                         @RequestParam(required = false) String copyNo,
                         @RequestParam(required = false) Integer borrowDays,
                         HttpServletRequest request,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForSuperAdmin());
            return "redirect:/admin/v2/admins";
        }
        Admin admin = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = borrowBusinessService.borrowByCopyNo(readerKey, copyNo, borrowDays, admin, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/borrows";
    }

    @PostMapping("/return")
    public String returnBook(@RequestParam(required = false) String copyNo,
                             HttpServletRequest request,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForSuperAdmin());
            return "redirect:/admin/v2/admins";
        }
        Admin admin = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = borrowBusinessService.returnByCopyNo(copyNo, admin, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/borrows";
    }

    @PostMapping("/shelf/{copyId}")
    public String confirmShelf(@PathVariable Integer copyId,
                               HttpServletRequest request,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isNormalAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForSuperAdmin());
            return "redirect:/admin/v2/admins";
        }
        Admin admin = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = borrowBusinessService.confirmShelf(copyId, admin, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/borrows";
    }

    private void addRedirectMessage(RedirectAttributes redirectAttributes, V2ActionResult result) {
        if (result == null) {
            redirectAttributes.addAttribute("error", "操作失败，请稍后重试。");
            return;
        }
        if (result.isSuccess()) {
            redirectAttributes.addAttribute("success", result.getMessage());
        } else {
            redirectAttributes.addAttribute("error", result.getMessage());
        }
    }
}

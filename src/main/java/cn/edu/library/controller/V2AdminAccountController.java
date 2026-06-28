package cn.edu.library.controller;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.V2AdminManageMapper;
import cn.edu.library.service.V2AdminManageService;
import cn.edu.library.util.V2AdminRoleUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 【本次新增】超级管理员控制器。
 *
 * 超级管理员固定唯一账号 admin，只负责管理普通管理员，不直接管理读者和借阅业务。
 */
@Controller
@RequestMapping("/admin/v2")
public class V2AdminAccountController {

    @Resource
    private V2AdminManageMapper adminManageMapper;

    @Resource
    private V2AdminManageService adminManageService;

    @GetMapping("/admins")
    public String admins(@RequestParam(required = false) String keyword,
                         HttpSession session,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isSuperAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForNormalAdmin());
            return "redirect:/admin/v2/dashboard";
        }
        model.addAttribute("admins", adminManageMapper.listNormalAdmins(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-admins";
    }

    @PostMapping("/admins/add")
    public String addAdmin(@RequestParam String username,
                           @RequestParam String realName,
                           @RequestParam(required = false) String phone,
                           @RequestParam(required = false) String email,
                           @RequestParam(required = false) String password,
                           HttpSession session,
                           HttpServletRequest request,
                           RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isSuperAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForNormalAdmin());
            return "redirect:/admin/v2/dashboard";
        }
        Admin operator = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = adminManageService.addNormalAdmin(username, realName, phone, email, password, operator, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/admins";
    }

    @PostMapping("/admins/{id}/status")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam Integer status,
                               HttpSession session,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isSuperAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForNormalAdmin());
            return "redirect:/admin/v2/dashboard";
        }
        Admin operator = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = adminManageService.updateNormalAdminStatus(id, status, operator, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/admins";
    }

    @PostMapping("/admins/{id}/reset-password")
    public String resetPassword(@PathVariable Integer id,
                                @RequestParam(required = false) String password,
                                HttpSession session,
                                HttpServletRequest request,
                                RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isSuperAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForNormalAdmin());
            return "redirect:/admin/v2/dashboard";
        }
        Admin operator = V2AdminRoleUtil.currentAdmin(session);
        V2ActionResult result = adminManageService.resetNormalAdminPassword(id, password, operator, request);
        addRedirectMessage(redirectAttributes, result);
        return "redirect:/admin/v2/admins";
    }

    @GetMapping("/logs")
    public String logs(@RequestParam(required = false) String keyword,
                       @RequestParam(required = false) String module,
                       HttpSession session,
                       Model model,
                       RedirectAttributes redirectAttributes) {
        if (!V2AdminRoleUtil.isSuperAdmin(session)) {
            redirectAttributes.addAttribute("error", V2AdminRoleUtil.denyForNormalAdmin());
            return "redirect:/admin/v2/dashboard";
        }
        model.addAttribute("logs", adminManageMapper.listOperationLogs(keyword, module));
        model.addAttribute("keyword", keyword);
        model.addAttribute("module", module);
        return "admin/v2-admin-logs";
    }

    private void addRedirectMessage(RedirectAttributes redirectAttributes, V2ActionResult result) {
        if (result == null) {
            redirectAttributes.addAttribute("error", "操作失败，请稍后重试。 ");
            return;
        }
        if (result.isSuccess()) {
            redirectAttributes.addAttribute("success", result.getMessage());
        } else {
            redirectAttributes.addAttribute("error", result.getMessage());
        }
    }
}

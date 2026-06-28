package cn.edu.library.controller;

import cn.edu.library.entity.Admin;
import cn.edu.library.entity.Reader;
import cn.edu.library.mapper.V2AdminManageMapper;
import cn.edu.library.service.AdminService;
import cn.edu.library.service.ReaderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 【本次修改】登录控制器。
 *
 * 修复点：
 * 1. 管理员登录后按角色分流：
 *    SUPER_ADMIN -> /admin/v2/admins
 *    ADMIN       -> /admin/v2/dashboard
 * 2. 登录成功写入 operation_log。
 * 3. 登录校验交给 AdminService / ReaderService，由 Mapper 统一限制 status = 1。
 */
@Controller
public class LoginController {

    @Resource
    private AdminService adminService;

    @Resource
    private ReaderService readerService;

    @Resource
    private V2AdminManageMapper v2AdminManageMapper;

    @GetMapping({"/login", "/"})
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam String userType,
                        Model model,
                        HttpSession session,
                        HttpServletRequest request) {
        String loginName = username == null ? "" : username.trim();
        String rawPassword = password == null ? "" : password.trim();
        String loginType = userType == null ? "" : userType.trim().toLowerCase();

        if ("admin".equals(loginType)) {
            Admin admin = adminService.login(loginName, rawPassword);
            if (admin != null) {
                session.setAttribute("loginUser", admin);
                session.setAttribute("userType", "ADMIN");
                session.setAttribute("loginRole", "ADMIN");
                session.setAttribute("adminRole", admin.getRole());

                logLogin("ADMIN", admin.getId(), adminName(admin), admin.getRole(), request);

                if ("SUPER_ADMIN".equals(admin.getRole())) {
                    return "redirect:/admin/v2/admins";
                }
                return "redirect:/admin/v2/dashboard";
            }
        }

        if ("reader".equals(loginType)) {
            Reader reader = readerService.login(loginName, rawPassword);
            if (reader != null) {
                session.setAttribute("loginUser", reader);
                session.setAttribute("userType", "READER");
                session.setAttribute("loginRole", "READER");

                logLogin("READER", reader.getId(), readerName(reader), "READER", request);

                return "redirect:/reader/v2/home";
            }
        }

        model.addAttribute("error", "账号、密码或用户身份错误，禁用账号不能登录。");
        model.addAttribute("username", loginName);
        model.addAttribute("userType", loginType);
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    private void logLogin(String operatorType,
                          Integer operatorId,
                          String operatorName,
                          String role,
                          HttpServletRequest request) {
        try {
            v2AdminManageMapper.addOperationLog(
                    operatorType,
                    operatorId,
                    operatorName,
                    "登录",
                    "LOGIN：用户登录成功，角色=" + role,
                    request == null ? "" : request.getRequestURI(),
                    request == null ? "" : request.getRemoteAddr()
            );
        } catch (Exception ignored) {
            // 登录日志不能影响登录主流程。
        }
    }

    private String adminName(Admin admin) {
        if (admin == null) {
            return "未知管理员";
        }
        if (!isBlank(admin.getRealName())) {
            return admin.getRealName();
        }
        return isBlank(admin.getUsername()) ? "未知管理员" : admin.getUsername();
    }

    private String readerName(Reader reader) {
        if (reader == null) {
            return "未知读者";
        }
        if (!isBlank(reader.getName())) {
            return reader.getName();
        }
        if (!isBlank(reader.getReaderNo())) {
            return reader.getReaderNo();
        }
        return isBlank(reader.getUsername()) ? "未知读者" : reader.getUsername();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

package cn.edu.library.service;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.V2AdminManageMapper;
import cn.edu.library.util.Md5Util;
import cn.edu.library.util.V2AdminRoleUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 【本次新增】超级管理员管理普通管理员账号 Service。
 */
@Service
public class V2AdminManageService {

    @Resource
    private V2AdminManageMapper adminManageMapper;

    @Transactional
    public V2ActionResult addNormalAdmin(String username,
                                         String realName,
                                         String phone,
                                         String email,
                                         String password,
                                         Admin operator,
                                         HttpServletRequest request) {
        String name = trim(username);
        String real = trim(realName);
        String pwd = trim(password);
        if (name.length() == 0) {
            return V2ActionResult.fail("请输入普通管理员用户名。 ");
        }
        if ("admin".equalsIgnoreCase(name)) {
            return V2ActionResult.fail("admin 是唯一超级管理员账号，不能作为普通管理员用户名。 ");
        }
        if (real.length() == 0) {
            return V2ActionResult.fail("请输入普通管理员姓名。 ");
        }
        if (pwd.length() == 0) {
            pwd = "123456";
        }
        if (adminManageMapper.countUsername(name) > 0) {
            return V2ActionResult.fail("用户名已存在：" + name);
        }
        String encoded = Md5Util.md5(pwd);
        adminManageMapper.addNormalAdmin(name, encoded, real, trim(phone), trim(email));
        String message = "新增普通管理员成功：" + name + "（" + real + "）。";
        log(operator, "ADMIN_MANAGE", "ADMIN_ADD", message, request);
        return V2ActionResult.ok(message);
    }

    @Transactional
    public V2ActionResult updateNormalAdminStatus(Integer id, Integer status, Admin operator, HttpServletRequest request) {
        if (id == null) {
            return V2ActionResult.fail("缺少管理员 ID。 ");
        }
        Map<String, Object> target = adminManageMapper.findAdminById(id);
        if (target == null) {
            return V2ActionResult.fail("管理员账号不存在。 ");
        }
        if (!"ADMIN".equals(String.valueOf(target.get("role")))) {
            return V2ActionResult.fail("只能管理普通管理员，不能修改超级管理员账号。 ");
        }
        int newStatus = status == null || status != 1 ? 0 : 1;
        adminManageMapper.updateNormalAdminStatus(id, newStatus);
        String username = String.valueOf(target.get("username"));
        String message = (newStatus == 1 ? "启用" : "禁用") + "普通管理员成功：" + username;
        log(operator, "ADMIN_MANAGE", newStatus == 1 ? "ADMIN_ENABLE" : "ADMIN_DISABLE", message, request);
        return V2ActionResult.ok(message);
    }

    @Transactional
    public V2ActionResult resetNormalAdminPassword(Integer id, String newPassword, Admin operator, HttpServletRequest request) {
        if (id == null) {
            return V2ActionResult.fail("缺少管理员 ID。 ");
        }
        String pwd = trim(newPassword);
        if (pwd.length() == 0) {
            pwd = "123456";
        }
        Map<String, Object> target = adminManageMapper.findAdminById(id);
        if (target == null) {
            return V2ActionResult.fail("管理员账号不存在。 ");
        }
        if (!"ADMIN".equals(String.valueOf(target.get("role")))) {
            return V2ActionResult.fail("只能重置普通管理员密码，不能重置超级管理员账号。 ");
        }
        adminManageMapper.resetNormalAdminPassword(id, Md5Util.md5(pwd));
        String username = String.valueOf(target.get("username"));
        String message = "重置普通管理员密码成功：" + username;
        log(operator, "ADMIN_MANAGE", "ADMIN_RESET_PASSWORD", message, request);
        return V2ActionResult.ok(message);
    }

    private String trim(String text) {
        return text == null ? "" : text.trim();
    }

    private void log(Admin admin, String module, String operation, String message, HttpServletRequest request) {
        try {
            adminManageMapper.addOperationLog(
                    "ADMIN",
                    admin == null ? null : admin.getId(),
                    V2AdminRoleUtil.safeName(admin),
                    module,
                    operation + "：" + message,
                    request == null ? "" : request.getRequestURI(),
                    request == null ? "" : request.getRemoteAddr()
            );
        } catch (Exception ignored) {
        }
    }
}

package cn.edu.library.util;

import cn.edu.library.entity.Admin;

import javax.servlet.http.HttpSession;

/**
 * 【本次新增】v2 管理端角色工具。
 *
 * 角色边界：
 * 1. SUPER_ADMIN：固定唯一 admin，负责普通管理员账号、系统维护、操作日志。
 * 2. ADMIN：普通管理员，负责读者、图书、借阅、罚款、座位等日常业务。
 */
public class V2AdminRoleUtil {

    public static Admin currentAdmin(HttpSession session) {
        Object user = session == null ? null : session.getAttribute("loginUser");
        if (user instanceof Admin) {
            return (Admin) user;
        }
        return null;
    }

    public static String currentRole(HttpSession session) {
        Object role = session == null ? null : session.getAttribute("adminRole");
        return role == null ? "" : String.valueOf(role);
    }

    public static boolean isSuperAdmin(HttpSession session) {
        return "SUPER_ADMIN".equals(currentRole(session));
    }

    public static boolean isNormalAdmin(HttpSession session) {
        return "ADMIN".equals(currentRole(session));
    }

    public static String denyForSuperAdmin() {
        return "超级管理员只负责普通管理员账号、系统维护和操作日志，不参与读者与借阅业务。请使用普通管理员账号办理该业务。";
    }

    public static String denyForNormalAdmin() {
        return "当前账号为普通管理员，无权访问超级管理员功能。";
    }

    public static String safeName(Admin admin) {
        if (admin == null) {
            return "unknown";
        }
        if (admin.getRealName() != null && admin.getRealName().trim().length() > 0) {
            return admin.getRealName().trim();
        }
        return admin.getUsername();
    }
}

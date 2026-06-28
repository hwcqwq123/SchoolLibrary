package cn.edu.library.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.AdminMapper;
import cn.edu.library.service.AdminService;
import cn.edu.library.util.Md5Util;

/**
 * 管理员服务。
 */
@Service
public class AdminServiceImpl implements AdminService {

    @Resource
    private AdminMapper adminMapper;

    @Override
    public Admin login(String username, String password) {
        if (isBlank(username) || password == null) {
            return null;
        }

        return adminMapper.login(username.trim(), password);
    }

    @Override
    public boolean changePassword(Integer adminId, String oldPassword, String newPassword) {
        if (adminId == null || isBlank(oldPassword) || isBlank(newPassword)) {
            return false;
        }

        Admin admin = adminMapper.findById(adminId);
        if (admin == null || !Integer.valueOf(1).equals(admin.getStatus())) {
            return false;
        }

        String dbPassword = admin.getPassword();
        String oldPasswordMd5 = Md5Util.md5(oldPassword);

        boolean oldPasswordMatched =
                oldPassword.equals(dbPassword)
                        || oldPasswordMd5.equalsIgnoreCase(dbPassword);

        if (!oldPasswordMatched) {
            return false;
        }

        return adminMapper.updatePassword(adminId, Md5Util.md5(newPassword)) > 0;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
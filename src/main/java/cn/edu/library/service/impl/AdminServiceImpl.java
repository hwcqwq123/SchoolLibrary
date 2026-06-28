package cn.edu.library.service.impl;

import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.AdminMapper;
import cn.edu.library.service.AdminService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 【本次修改】管理员服务。
 *
 * 修复点：
 * 1. 登录统一走 AdminMapper.login，SQL 中已限制 status = 1。
 * 2. 避免禁用管理员仍可通过 findByUsername + 手动密码比对登录。
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
        return adminMapper.updatePassword(adminId, Md5Util.md5(newPassword)) > 0;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

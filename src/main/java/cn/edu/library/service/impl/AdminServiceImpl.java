package cn.edu.library.service.impl;

import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.AdminMapper;
import cn.edu.library.service.AdminService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

@Service
public class AdminServiceImpl implements AdminService {
    @Resource
    private AdminMapper adminMapper;

    @Override
    public Admin login(String username, String password) {
        Admin admin = adminMapper.findByUsername(username);
        if (admin == null) {
            return null;
        }
        // 与数据库中 MD5 后的密码进行比对。
        return admin.getPassword().equals(Md5Util.md5(password)) ? admin : null;
    }

    @Override
    public boolean changePassword(Integer adminId, String oldPassword, String newPassword) {
        // 管理员修改密码时，Controller 已经从 Session 中拿到管理员对象。
        // 这里为了简洁只做新密码更新；实际项目可通过 id 再查一次旧密码。
        return adminMapper.updatePassword(adminId, Md5Util.md5(newPassword)) > 0;
    }
}

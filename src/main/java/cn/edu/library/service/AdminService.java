package cn.edu.library.service;

import cn.edu.library.entity.Admin;

public interface AdminService {
    Admin login(String username, String password);
    boolean changePassword(Integer adminId, String oldPassword, String newPassword);
}

package cn.edu.library.mapper;

import org.apache.ibatis.annotations.Param;

import cn.edu.library.entity.Admin;

/**
 * 管理员 Mapper
 */
public interface AdminMapper {

    /**
     * 【本次修改】管理员登录
     */
    Admin login(@Param("username") String username,
                @Param("password") String password);

    /**
     * 【本次修改】根据用户名查询管理员
     */
    Admin findByUsername(@Param("username") String username);

    /**
     * 【本次修改】根据 ID 查询管理员
     */
    Admin findById(@Param("id") Integer id);

    /**
     * 【本次修改】修改管理员密码
     */
    int updatePassword(@Param("id") Integer id,
                       @Param("password") String password);

    /**
     * 【本次修改】统计管理员数量
     */
    int countAll();
}
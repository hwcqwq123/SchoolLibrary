package cn.edu.library.mapper;

import cn.edu.library.entity.Admin;
import org.apache.ibatis.annotations.Param;

/** 管理员 Mapper，负责 admin 表数据库操作。 */
public interface AdminMapper {
    Admin findByUsername(@Param("username") String username);
    int updatePassword(@Param("id") Integer id, @Param("password") String password);
}

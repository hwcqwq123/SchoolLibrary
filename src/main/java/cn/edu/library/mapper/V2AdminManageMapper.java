package cn.edu.library.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

/**
 * 【本次修改】超级管理员管理普通管理员账号 Mapper。
 *
 * 修复点：
 * 1. 修复 listNormalAdmins / listOperationLogs 原先 @Select("") 空 SQL 的运行时风险。
 * 2. SUPER_ADMIN 固定唯一为 admin，只管理 role='ADMIN' 的普通管理员。
 */
public interface V2AdminManageMapper {

    @Select({
            "<script>",
            "SELECT",
            "  id AS id,",
            "  username AS username,",
            "  real_name AS realName,",
            "  phone AS phone,",
            "  email AS email,",
            "  status AS status,",
            "  create_time AS createTime,",
            "  update_time AS updateTime",
            "FROM admin",
            "WHERE role = 'ADMIN'",
            "<if test='keyword != null and keyword != \"\"'>",
            "  AND (",
            "       username LIKE CONCAT('%', #{keyword}, '%')",
            "       OR real_name LIKE CONCAT('%', #{keyword}, '%')",
            "       OR phone LIKE CONCAT('%', #{keyword}, '%')",
            "       OR email LIKE CONCAT('%', #{keyword}, '%')",
            "  )",
            "</if>",
            "ORDER BY id DESC",
            "</script>"
    })
    List<Map<String, Object>> listNormalAdmins(@Param("keyword") String keyword);

    @Select("SELECT COUNT(1) FROM admin WHERE username = #{username}")
    int countUsername(@Param("username") String username);

    @Insert("INSERT INTO admin(username, password, real_name, role, phone, email, status, create_time) "
            + "VALUES(#{username}, #{password}, #{realName}, 'ADMIN', #{phone}, #{email}, 1, NOW())")
    int addNormalAdmin(@Param("username") String username,
                       @Param("password") String password,
                       @Param("realName") String realName,
                       @Param("phone") String phone,
                       @Param("email") String email);

    @Select("SELECT id AS id, username AS username, real_name AS realName, role AS role, status AS status "
            + "FROM admin WHERE id = #{id}")
    Map<String, Object> findAdminById(@Param("id") Integer id);

    @Update("UPDATE admin SET status = #{status}, update_time = NOW() WHERE id = #{id} AND role = 'ADMIN'")
    int updateNormalAdminStatus(@Param("id") Integer id, @Param("status") Integer status);

    @Update("UPDATE admin SET password = #{password}, update_time = NOW() WHERE id = #{id} AND role = 'ADMIN'")
    int resetNormalAdminPassword(@Param("id") Integer id, @Param("password") String password);

    @Select({
            "<script>",
            "SELECT",
            "  id AS id,",
            "  operator_type AS operatorType,",
            "  operator_id AS operatorId,",
            "  operator_name AS operatorName,",
            "  module AS module,",
            "  COALESCE(operation, action) AS operation,",
            "  COALESCE(request_url, description) AS requestUrl,",
            "  ip AS ip,",
            "  result AS result,",
            "  create_time AS createTime",
            "FROM operation_log",
            "WHERE 1 = 1",
            "<if test='module != null and module != \"\"'>",
            "  AND module = #{module}",
            "</if>",
            "<if test='keyword != null and keyword != \"\"'>",
            "  AND (",
            "       operator_name LIKE CONCAT('%', #{keyword}, '%')",
            "       OR module LIKE CONCAT('%', #{keyword}, '%')",
            "       OR operation LIKE CONCAT('%', #{keyword}, '%')",
            "       OR action LIKE CONCAT('%', #{keyword}, '%')",
            "       OR request_url LIKE CONCAT('%', #{keyword}, '%')",
            "       OR description LIKE CONCAT('%', #{keyword}, '%')",
            "       OR ip LIKE CONCAT('%', #{keyword}, '%')",
            "  )",
            "</if>",
            "ORDER BY create_time DESC, id DESC",
            "LIMIT 300",
            "</script>"
    })
    List<Map<String, Object>> listOperationLogs(@Param("keyword") String keyword,
                                                @Param("module") String module);

    @Insert("INSERT INTO operation_log(operator_type, operator_id, operator_name, module, operation, request_url, ip, create_time) "
            + "VALUES(#{operatorType}, #{operatorId}, #{operatorName}, #{module}, #{operation}, #{requestUrl}, #{ip}, NOW())")
    int addOperationLog(@Param("operatorType") String operatorType,
                        @Param("operatorId") Integer operatorId,
                        @Param("operatorName") String operatorName,
                        @Param("module") String module,
                        @Param("operation") String operation,
                        @Param("requestUrl") String requestUrl,
                        @Param("ip") String ip);
}

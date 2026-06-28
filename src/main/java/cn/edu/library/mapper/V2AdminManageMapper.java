package cn.edu.library.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

/**
 * 【本次新增】超级管理员管理普通管理员账号 Mapper。
 */
public interface V2AdminManageMapper {

    @Select({"<script>",
            "SELECT id AS id, username AS username, real_name AS realName, role AS role, phone AS phone, email AS email, status AS status, create_time AS createTime, update_time AS updateTime ",
            "FROM admin WHERE role = 'ADMIN' ",
            "<if test='keyword != null and keyword != \"\"'>",
            "AND (username LIKE CONCAT('%', #{keyword}, '%') OR real_name LIKE CONCAT('%', #{keyword}, '%') OR phone LIKE CONCAT('%', #{keyword}, '%') OR email LIKE CONCAT('%', #{keyword}, '%')) ",
            "</if>",
            "ORDER BY status DESC, id DESC",
            "</script>"})
    List<Map<String, Object>> listNormalAdmins(@Param("keyword") String keyword);

    @Select("SELECT COUNT(1) FROM admin WHERE username = #{username}")
    int countUsername(@Param("username") String username);

    @Insert("INSERT INTO admin(username, password, real_name, role, phone, email, status, create_time) " +
            "VALUES(#{username}, #{password}, #{realName}, 'ADMIN', #{phone}, #{email}, 1, NOW())")
    int addNormalAdmin(@Param("username") String username,
                       @Param("password") String password,
                       @Param("realName") String realName,
                       @Param("phone") String phone,
                       @Param("email") String email);

    @Select("SELECT id AS id, username AS username, real_name AS realName, role AS role, status AS status FROM admin WHERE id = #{id}")
    Map<String, Object> findAdminById(@Param("id") Integer id);

    @Update("UPDATE admin SET status = #{status}, update_time = NOW() WHERE id = #{id} AND role = 'ADMIN'")
    int updateNormalAdminStatus(@Param("id") Integer id, @Param("status") Integer status);

    @Update("UPDATE admin SET password = #{password}, update_time = NOW() WHERE id = #{id} AND role = 'ADMIN'")
    int resetNormalAdminPassword(@Param("id") Integer id, @Param("password") String password);

    @Select({"<script>",
            "SELECT id AS id, operator_type AS operatorType, operator_id AS operatorId, operator_name AS operatorName, module AS module, operation AS operation, request_url AS requestUrl, ip AS ip, create_time AS createTime ",
            "FROM operation_log WHERE 1 = 1 ",
            "<if test='keyword != null and keyword != \"\"'>",
            "AND (operator_name LIKE CONCAT('%', #{keyword}, '%') OR operation LIKE CONCAT('%', #{keyword}, '%') OR request_url LIKE CONCAT('%', #{keyword}, '%')) ",
            "</if>",
            "<if test='module != null and module != \"\"'>",
            "AND module = #{module} ",
            "</if>",
            "ORDER BY create_time DESC LIMIT 300",
            "</script>"})
    List<Map<String, Object>> listOperationLogs(@Param("keyword") String keyword, @Param("module") String module);

    @Insert("INSERT INTO operation_log(operator_type, operator_id, operator_name, module, operation, request_url, ip, create_time) " +
            "VALUES(#{operatorType}, #{operatorId}, #{operatorName}, #{module}, #{operation}, #{requestUrl}, #{ip}, NOW())")
    int addOperationLog(@Param("operatorType") String operatorType,
                        @Param("operatorId") Integer operatorId,
                        @Param("operatorName") String operatorName,
                        @Param("module") String module,
                        @Param("operation") String operation,
                        @Param("requestUrl") String requestUrl,
                        @Param("ip") String ip);
}

package cn.edu.library.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cn.edu.library.entity.Reader;

/**
 * 读者 Mapper 接口
 *
 * 【本次修改】
 * 说明：
 * 1. 这个文件是 Java 接口文件，只能写 Java 代码。
 * 2. 不能把 <select>、<update>、#{username} 这类 MyBatis XML 写到这里。
 * 3. SQL 语句应该写在 src/main/resources/mapper/ReaderMapper.xml。
 */
public interface ReaderMapper {

    /**
     * 【本次修改】读者登录
     * 支持 username / reader_no / student_no 登录，具体 SQL 写在 ReaderMapper.xml。
     */
    Reader login(@Param("username") String username,
                 @Param("password") String password);

    /**
     * 【本次修改】根据 ID 查询读者
     */
    Reader findById(@Param("id") Integer id);

    /**
     * 【本次修改】根据读者编号查询读者
     */
    Reader findByReaderNo(@Param("readerNo") String readerNo);

    /**
     * 【本次修改】读者列表查询
     */
    List<Reader> search(@Param("keyword") String keyword);

    /**
     * 新增读者
     */
    int insert(Reader reader);

    /**
     * 修改读者
     */
    int update(Reader reader);

    /**
     * 【本次修改】逻辑删除/禁用读者
     * 保留 delete 是为了兼容旧代码。
     */
    int delete(@Param("id") Integer id);

    /**
     * 【本次修改】逻辑禁用读者
     * 你当前 ReaderServiceImpl.java 里调用的是 readerMapper.disable(id)，所以这里必须有这个方法。
     */
    int disable(@Param("id") Integer id);

    /**
     * 修改读者密码
     */
    int updatePassword(@Param("id") Integer id,
                       @Param("password") String password);

    /**
     * 统计读者总数
     */
    int countAll();
}
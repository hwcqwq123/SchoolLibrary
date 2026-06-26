package cn.edu.library.mapper;

import cn.edu.library.entity.Reader;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/** 读者 Mapper，负责 reader 表数据库操作。 */
public interface ReaderMapper {
    Reader findById(@Param("id") Integer id);
    Reader findByReaderNo(@Param("readerNo") String readerNo);
    List<Reader> search(@Param("keyword") String keyword);
    int insert(Reader reader);
    int update(Reader reader);
    int disable(@Param("id") Integer id);
    int updatePassword(@Param("id") Integer id, @Param("password") String password);
    int countAll();
}

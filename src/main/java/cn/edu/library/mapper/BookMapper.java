package cn.edu.library.mapper;

import cn.edu.library.entity.Book;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/** 图书 Mapper，负责 book 表数据库操作。 */
public interface BookMapper {
    Book findById(@Param("id") Integer id);
    Book findByBookNo(@Param("bookNo") String bookNo);
    List<Book> search(@Param("keyword") String keyword, @Param("category") String category);
    int insert(Book book);
    int update(Book book);
    int delete(@Param("id") Integer id);
    int decreaseAvailable(@Param("id") Integer id);
    int increaseAvailable(@Param("id") Integer id);
    int countAll();
}

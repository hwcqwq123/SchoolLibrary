package cn.edu.library.mapper;

import cn.edu.library.entity.BorrowRecord;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/** 借阅 Mapper，负责 borrow_record 表数据库操作。 */
public interface BorrowMapper {
    BorrowRecord findById(@Param("id") Integer id);
    List<BorrowRecord> search(@Param("keyword") String keyword, @Param("status") String status);
    List<BorrowRecord> findByReaderId(@Param("readerId") Integer readerId);
    int insert(BorrowRecord record);
    int returnBook(BorrowRecord record);
    int countBorrowed();
    int countOverdue();
    int countBorrowingByReaderAndBook(@Param("readerId") Integer readerId, @Param("bookId") Integer bookId);
}

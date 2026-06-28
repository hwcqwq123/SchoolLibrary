package cn.edu.library.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

/**
 * 【本次修改】v2 借阅办理 Mapper。
 *
 * 读者端只查询图书状态；普通管理员按实体书编码办理借书、还书、确认上架。
 */
public interface V2BorrowAdminMapper {

    @Select("SELECT id AS id, reader_no AS readerNo, username AS username, student_no AS studentNo, " +
            "name AS name, status AS status " +
            "FROM reader " +
            "WHERE status = 1 " +
            "AND (reader_no = #{keyword} OR username = #{keyword} OR student_no = #{keyword} OR name = #{keyword}) " +
            "LIMIT 1")
    Map<String, Object> findActiveReaderForBorrow(@Param("keyword") String keyword);

    @Select("SELECT COUNT(1) FROM fine_record WHERE reader_id = #{readerId} AND status = 'UNPAID'")
    int countReaderUnpaidFines(@Param("readerId") Integer readerId);

    @Select("SELECT COUNT(1) FROM borrow_record WHERE reader_id = #{readerId} AND status = 'BORROWED'")
    int countReaderBorrowing(@Param("readerId") Integer readerId);

    @Select("SELECT COUNT(1) FROM borrow_record WHERE reader_id = #{readerId} AND book_id = #{bookId} AND status = 'BORROWED'")
    int countReaderBorrowingSameBook(@Param("readerId") Integer readerId, @Param("bookId") Integer bookId);

    @Select("SELECT bc.id AS id, bc.book_id AS bookId, bc.copy_no AS copyNo, bc.shelf_status AS shelfStatus, " +
            "bc.available_at AS availableAt, bc.return_process_start_time AS returnProcessStartTime, " +
            "b.book_no AS bookNo, b.book_name AS bookName, b.author AS author, b.available_count AS availableCount, " +
            "b.total_count AS totalCount " +
            "FROM book_copy bc LEFT JOIN book b ON bc.book_id = b.id " +
            "WHERE bc.copy_no = #{copyNo} AND bc.status = 1 LIMIT 1")
    Map<String, Object> findCopyByCopyNo(@Param("copyNo") String copyNo);

    @Insert("INSERT INTO borrow_record(reader_id, book_id, copy_id, copy_no, borrow_admin_id, " +
            "borrow_time, due_time, borrow_date, due_date, status, renew_count, fine, fine_status, create_time) " +
            "VALUES(#{readerId}, #{bookId}, #{copyId}, #{copyNo}, #{adminId}, " +
            "NOW(), DATE_ADD(NOW(), INTERVAL #{borrowDays} DAY), NOW(), DATE_ADD(NOW(), INTERVAL #{borrowDays} DAY), " +
            "'BORROWED', 0, 0, 'NONE', NOW())")
    int insertBorrowRecord(@Param("readerId") Integer readerId,
                           @Param("bookId") Integer bookId,
                           @Param("copyId") Integer copyId,
                           @Param("copyNo") String copyNo,
                           @Param("adminId") Integer adminId,
                           @Param("borrowDays") Integer borrowDays);

    @Update("UPDATE book_copy bc SET bc.shelf_status = 'BORROWED', " +
            "bc.current_borrow_id = (SELECT br.id FROM borrow_record br WHERE br.copy_id = bc.id AND br.status = 'BORROWED' ORDER BY br.id DESC LIMIT 1), " +
            "bc.update_time = NOW() " +
            "WHERE bc.id = #{copyId} AND bc.shelf_status = 'ON_SHELF'")
    int markCopyBorrowed(@Param("copyId") Integer copyId);

    @Update("UPDATE book SET available_count = GREATEST(IFNULL(available_count, 0) - 1, 0), " +
            "borrow_count = IFNULL(borrow_count, 0) + 1, update_time = NOW() WHERE id = #{bookId}")
    int decreaseBookAvailable(@Param("bookId") Integer bookId);

    @Select("SELECT br.id AS id, br.reader_id AS readerId, br.book_id AS bookId, br.copy_id AS copyId, br.copy_no AS copyNo, " +
            "br.due_date AS dueDate, r.name AS readerName, r.reader_no AS readerNo, b.book_name AS bookName " +
            "FROM borrow_record br " +
            "LEFT JOIN reader r ON br.reader_id = r.id " +
            "LEFT JOIN book b ON br.book_id = b.id " +
            "WHERE br.copy_no = #{copyNo} AND br.status = 'BORROWED' " +
            "ORDER BY br.id DESC LIMIT 1")
    Map<String, Object> findActiveBorrowByCopyNo(@Param("copyNo") String copyNo);

    @Update("UPDATE borrow_record SET " +
            "return_time = NOW(), return_date = NOW(), return_admin_id = #{adminId}, " +
            "status = CASE WHEN due_date < CURDATE() THEN 'OVERDUE_RETURNED' ELSE 'RETURNED' END, " +
            "fine = CASE WHEN due_date < CURDATE() THEN DATEDIFF(CURDATE(), due_date) * 0.50 ELSE 0 END, " +
            "fine_status = CASE WHEN due_date < CURDATE() THEN 'UNPAID' ELSE 'NONE' END, " +
            "update_time = NOW() " +
            "WHERE id = #{borrowId} AND status = 'BORROWED'")
    int markBorrowReturned(@Param("borrowId") Integer borrowId, @Param("adminId") Integer adminId);

    @Insert("INSERT INTO fine_record(borrow_record_id, borrow_id, reader_id, amount, status, create_time) " +
            "SELECT br.id, br.id, br.reader_id, DATEDIFF(CURDATE(), br.due_date) * 0.50, 'UNPAID', NOW() " +
            "FROM borrow_record br " +
            "WHERE br.id = #{borrowId} AND br.due_date < CURDATE() " +
            "AND NOT EXISTS (SELECT 1 FROM fine_record fr WHERE fr.borrow_record_id = br.id OR fr.borrow_id = br.id)")
    int generateFineIfOverdue(@Param("borrowId") Integer borrowId);

    @Update("UPDATE book_copy SET shelf_status = 'RETURN_PROCESSING', current_borrow_id = NULL, " +
            "return_process_start_time = NOW(), available_at = DATE_ADD(NOW(), INTERVAL 2 DAY), update_time = NOW() " +
            "WHERE id = #{copyId} AND shelf_status = 'BORROWED'")
    int markCopyReturnProcessing(@Param("copyId") Integer copyId);

    @Select("SELECT bc.id AS id, bc.copy_no AS copyNo, bc.book_id AS bookId, bc.shelf_status AS shelfStatus, " +
            "bc.return_process_start_time AS returnProcessStartTime, bc.available_at AS availableAt, " +
            "b.book_no AS bookNo, b.book_name AS bookName, b.author AS author " +
            "FROM book_copy bc LEFT JOIN book b ON bc.book_id = b.id " +
            "WHERE bc.shelf_status = 'RETURN_PROCESSING' AND bc.status = 1 " +
            "ORDER BY bc.available_at ASC, bc.id ASC")
    List<Map<String, Object>> listReturnProcessingCopies();

    @Select("SELECT id AS id, copy_no AS copyNo, book_id AS bookId FROM book_copy " +
            "WHERE shelf_status = 'RETURN_PROCESSING' AND available_at <= NOW() AND status = 1")
    List<Map<String, Object>> listExpiredProcessingCopies();

    @Select("SELECT id AS id, copy_no AS copyNo, book_id AS bookId, shelf_status AS shelfStatus FROM book_copy WHERE id = #{copyId}")
    Map<String, Object> findCopyById(@Param("copyId") Integer copyId);

    @Update("UPDATE book_copy SET shelf_status = 'ON_SHELF', shelf_time = NOW(), " +
            "return_process_start_time = NULL, available_at = NULL, update_time = NOW() " +
            "WHERE id = #{copyId} AND shelf_status = 'RETURN_PROCESSING'")
    int markCopyOnShelf(@Param("copyId") Integer copyId);

    @Update("UPDATE borrow_record SET shelf_admin_id = #{adminId}, shelf_time = NOW(), update_time = NOW() " +
            "WHERE copy_id = #{copyId} AND status IN ('RETURNED', 'OVERDUE_RETURNED') " +
            "ORDER BY id DESC LIMIT 1")
    int markBorrowShelfConfirmed(@Param("copyId") Integer copyId, @Param("adminId") Integer adminId);

    @Update("UPDATE book SET available_count = LEAST(IFNULL(total_count, 0), IFNULL(available_count, 0) + 1), update_time = NOW() WHERE id = #{bookId}")
    int increaseBookAvailable(@Param("bookId") Integer bookId);

    @Select("SELECT br.id AS id, r.reader_no AS readerNo, r.name AS readerName, " +
            "b.book_no AS bookNo, b.book_name AS bookName, br.copy_no AS copyNo, " +
            "br.borrow_date AS borrowDate, br.due_date AS dueDate, br.return_date AS returnDate, br.status AS status, br.fine AS fine " +
            "FROM borrow_record br " +
            "LEFT JOIN reader r ON br.reader_id = r.id " +
            "LEFT JOIN book b ON br.book_id = b.id " +
            "ORDER BY br.borrow_date DESC LIMIT #{limit}")
    List<Map<String, Object>> listRecentBorrowRecords(@Param("limit") Integer limit);

    @Select("SELECT br.id AS id, r.reader_no AS readerNo, r.name AS readerName, " +
            "b.book_name AS bookName, br.copy_no AS copyNo, br.due_date AS dueDate, " +
            "DATEDIFF(CURDATE(), br.due_date) AS overdueDays, DATEDIFF(CURDATE(), br.due_date) * 0.50 AS fine " +
            "FROM borrow_record br " +
            "LEFT JOIN reader r ON br.reader_id = r.id " +
            "LEFT JOIN book b ON br.book_id = b.id " +
            "WHERE br.status = 'BORROWED' AND br.due_date < CURDATE() " +
            "ORDER BY br.due_date ASC")
    List<Map<String, Object>> listOverdueBorrowRecords();

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

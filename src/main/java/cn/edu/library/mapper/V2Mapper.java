package cn.edu.library.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

/**
 * v2 通用 Mapper。
 */
public interface V2Mapper {

    Map<String, Object> dashboardStats();

    List<Map<String, Object>> categoryStats();

    List<Map<String, Object>> latestNotices(@Param("limit") Integer limit);

    List<Map<String, Object>> recommendBooks(@Param("limit") Integer limit);

    List<Map<String, Object>> recentBorrows(@Param("limit") Integer limit);

    List<Map<String, Object>> overdueList();

    List<Map<String, Object>> listCategories(@Param("keyword") String keyword);

    Map<String, Object> findCategory(@Param("id") Integer id);

    int addCategory(@Param("categoryName") String categoryName,
                    @Param("description") String description);

    int updateCategory(@Param("id") Integer id,
                       @Param("categoryName") String categoryName,
                       @Param("description") String description,
                       @Param("status") Integer status);

    int disableCategory(@Param("id") Integer id);

    List<Map<String, Object>> listNotices(@Param("keyword") String keyword);

    Map<String, Object> findNotice(@Param("id") Integer id);

    int addNotice(@Param("title") String title,
                  @Param("content") String content,
                  @Param("publisherId") Integer publisherId,
                  @Param("status") Integer status);

    int updateNotice(@Param("id") Integer id,
                     @Param("title") String title,
                     @Param("content") String content,
                     @Param("status") Integer status);

    int deleteNotice(@Param("id") Integer id);

    List<Map<String, Object>> listRenewRequests(@Param("status") String status);

    int addRenewRequest(@Param("borrowRecordId") Integer borrowRecordId,
                        @Param("readerId") Integer readerId,
                        @Param("reason") String reason);

    int approveRenew(@Param("id") Integer id,
                     @Param("handlerId") Integer handlerId,
                     @Param("handlerName") String handlerName,
                     @Param("remark") String remark);

    int rejectRenew(@Param("id") Integer id,
                    @Param("handlerId") Integer handlerId,
                    @Param("handlerName") String handlerName,
                    @Param("remark") String remark);

    int extendBorrowDueDate(@Param("borrowRecordId") Integer borrowRecordId);

    int increaseBorrowRenewCount(@Param("borrowRecordId") Integer borrowRecordId);

    List<Map<String, Object>> listFines(@Param("status") String status,
                                        @Param("keyword") String keyword);

    int generateOverdueFines();

    int markFinePaid(@Param("id") Integer id,
                     @Param("operatorId") Integer operatorId,
                     @Param("operatorName") String operatorName);

    int updateBorrowFinePaid(@Param("borrowRecordId") Integer borrowRecordId);

    List<Map<String, Object>> listFloors();

    List<Map<String, Object>> listSlots();

    List<Map<String, Object>> listSeats(@Param("floorId") Integer floorId,
                                        @Param("reservationDate") String reservationDate,
                                        @Param("timeSlotId") Integer timeSlotId,
                                        @Param("readerId") Integer readerId);

    int clearExpiredLocks();

    int countSeatConflict(@Param("seatId") Integer seatId,
                          @Param("reservationDate") String reservationDate,
                          @Param("timeSlotId") Integer timeSlotId);

    @Select({
            "SELECT COUNT(1)",
            "FROM seat_reservation",
            "WHERE reader_id = #{readerId}",
            "  AND reservation_date = #{reservationDate}",
            "  AND time_slot_id = #{timeSlotId}",
            "  AND status = 1"
    })
    int countReaderSeatTimeReservation(@Param("readerId") Integer readerId,
                                       @Param("reservationDate") String reservationDate,
                                       @Param("timeSlotId") Integer timeSlotId);

    @Select({
            "SELECT COUNT(1)",
            "FROM seat_time_slot",
            "WHERE id = #{timeSlotId}",
            "  AND STR_TO_DATE(CONCAT(#{reservationDate}, ' ', end_time), '%Y-%m-%d %H:%i:%s') <= NOW()"
    })
    int countPastSeatTimeSlot(@Param("reservationDate") String reservationDate,
                              @Param("timeSlotId") Integer timeSlotId);

    @Select({
            "SELECT COUNT(1)",
            "FROM library_seat",
            "WHERE id = #{seatId}",
            "  AND status = 1"
    })
    int countActiveSeat(@Param("seatId") Integer seatId);

    int lockSeat(@Param("seatId") Integer seatId,
                 @Param("readerId") Integer readerId,
                 @Param("reservationDate") String reservationDate,
                 @Param("timeSlotId") Integer timeSlotId,
                 @Param("expireTime") Date expireTime);

    int createSeatReservation(@Param("seatId") Integer seatId,
                              @Param("readerId") Integer readerId,
                              @Param("reservationDate") String reservationDate,
                              @Param("timeSlotId") Integer timeSlotId);

    int cancelSeatReservation(@Param("id") Integer id);

    int cancelOwnSeatReservation(@Param("id") Integer id,
                                 @Param("readerId") Integer readerId);

    List<Map<String, Object>> listSeatReservations(@Param("reservationDate") String reservationDate,
                                                   @Param("floorId") Integer floorId,
                                                   @Param("keyword") String keyword);

    List<Map<String, Object>> listReaderSeatReservations(@Param("readerId") Integer readerId);

    List<Map<String, Object>> searchBooks(@Param("keyword") String keyword,
                                          @Param("categoryId") Integer categoryId,
                                          @Param("onlyRecommend") Integer onlyRecommend);

    Map<String, Object> findBookDetail(@Param("id") Integer id);

    List<Map<String, Object>> listReaderBorrows(@Param("readerId") Integer readerId,
                                                @Param("history") Integer history);

    List<Map<String, Object>> listReaderBorrowHistory(@Param("readerId") Integer readerId);

    Map<String, Object> findReaderProfile(@Param("readerId") Integer readerId);

    int updateReaderProfile(@Param("readerId") Integer readerId,
                            @Param("phone") String phone,
                            @Param("email") String email,
                            @Param("avatar") String avatar);

    List<Map<String, Object>> listAdmins(@Param("keyword") String keyword);

    int addAdmin(@Param("username") String username,
                 @Param("password") String password,
                 @Param("realName") String realName,
                 @Param("role") String role,
                 @Param("phone") String phone,
                 @Param("email") String email);

    int disableAdmin(@Param("id") Integer id);

    List<Map<String, Object>> listOperationLogs(@Param("keyword") String keyword,
                                                @Param("module") String module);

    int addOperationLog(@Param("operatorType") String operatorType,
                        @Param("operatorId") Integer operatorId,
                        @Param("operatorName") String operatorName,
                        @Param("module") String module,
                        @Param("operation") String operation,
                        @Param("requestUrl") String requestUrl,
                        @Param("ip") String ip);

    List<Map<String, Object>> exportBooks();

    List<Map<String, Object>> exportBorrows();

    int importBook(@Param("bookNo") String bookNo,
                   @Param("bookName") String bookName,
                   @Param("author") String author,
                   @Param("publisher") String publisher,
                   @Param("categoryId") Integer categoryId,
                   @Param("totalCount") Integer totalCount,
                   @Param("availableCount") Integer availableCount);

    @Select({
            "SELECT COUNT(1)",
            "FROM borrow_record",
            "WHERE id = #{borrowRecordId}",
            "  AND reader_id = #{readerId}",
            "  AND status = 'BORROWED'"
    })
    int countBorrowCanRenew(@Param("borrowRecordId") Integer borrowRecordId,
                            @Param("readerId") Integer readerId);

    @Select({
            "SELECT COUNT(1)",
            "FROM renew_request",
            "WHERE borrow_record_id = #{borrowRecordId}",
            "  AND status = 'PENDING'"
    })
    int countPendingRenewRequest(@Param("borrowRecordId") Integer borrowRecordId);

    @Select({
            "SELECT COUNT(1)",
            "FROM renew_request",
            "WHERE id = #{id}",
            "  AND status = 'PENDING'"
    })
    int countPendingRenewById(@Param("id") Integer id);

    @Select({
            "SELECT COUNT(1)",
            "FROM renew_request",
            "WHERE id = #{id}",
            "  AND borrow_record_id = #{borrowRecordId}",
            "  AND status = 'PENDING'"
    })
    int countPendingRenewForBorrow(@Param("id") Integer id,
                                   @Param("borrowRecordId") Integer borrowRecordId);

    @Select({
            "SELECT COUNT(1)",
            "FROM fine_record",
            "WHERE id = #{id}",
            "  AND status = 'UNPAID'"
    })
    int countUnpaidFine(@Param("id") Integer id);

    @Select({
            "SELECT COUNT(1)",
            "FROM fine_record",
            "WHERE id = #{id}",
            "  AND borrow_record_id = #{borrowRecordId}",
            "  AND status = 'UNPAID'"
    })
    int countUnpaidFineForBorrow(@Param("id") Integer id,
                                 @Param("borrowRecordId") Integer borrowRecordId);

    @Select({
            "SELECT COUNT(1)",
            "FROM borrow_record",
            "WHERE id = #{borrowRecordId}"
    })
    int countBorrowRecord(@Param("borrowRecordId") Integer borrowRecordId);

    @Update({
            "UPDATE seat_lock",
            "SET status = 0",
            "WHERE seat_id = #{seatId}",
            "  AND reader_id = #{readerId}",
            "  AND reservation_date = #{reservationDate}",
            "  AND time_slot_id = #{timeSlotId}",
            "  AND status = 1"
    })
    int releaseSeatLock(@Param("seatId") Integer seatId,
                        @Param("readerId") Integer readerId,
                        @Param("reservationDate") String reservationDate,
                        @Param("timeSlotId") Integer timeSlotId);

    @Insert({
            "INSERT INTO fine_record(",
            "    borrow_record_id,",
            "    borrow_id,",
            "    reader_id,",
            "    book_id,",
            "    overdue_days,",
            "    amount,",
            "    status,",
            "    create_time",
            ")",
            "SELECT",
            "    br.id,",
            "    br.id,",
            "    br.reader_id,",
            "    br.book_id,",
            "    DATEDIFF(CURDATE(), br.due_date),",
            "    DATEDIFF(CURDATE(), br.due_date) * 0.50,",
            "    'UNPAID',",
            "    NOW()",
            "FROM borrow_record br",
            "WHERE br.status = 'BORROWED'",
            "  AND br.due_date < CURDATE()",
            "  AND NOT EXISTS (",
            "      SELECT 1",
            "      FROM fine_record fr",
            "      WHERE fr.borrow_record_id = br.id",
            "  )"
    })
    int generateOverdueFinesFinal();

    @Update({
            "UPDATE borrow_record br",
            "JOIN fine_record fr ON fr.borrow_record_id = br.id",
            "SET br.overdue_days = fr.overdue_days,",
            "    br.fine = fr.amount,",
            "    br.fine_status = 'UNPAID',",
            "    br.update_time = NOW()",
            "WHERE fr.status = 'UNPAID'",
            "  AND br.status = 'BORROWED'"
    })
    int syncBorrowFineStatus();
}
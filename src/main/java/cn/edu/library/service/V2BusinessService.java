package cn.edu.library.service;

import java.util.Calendar;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.mapper.V2Mapper;

/**
 * v2 关键业务服务。
 */
@Service
public class V2BusinessService {

    @Resource
    private V2Mapper v2Mapper;

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult applyRenew(Integer borrowRecordId,
                                     Integer readerId,
                                     String reason,
                                     String operatorName,
                                     String requestUrl,
                                     String ip) {
        if (readerId == null) {
            return V2ActionResult.error("NOT_LOGIN", "请先登录后再申请续借");
        }

        if (borrowRecordId == null || borrowRecordId <= 0) {
            return V2ActionResult.error("INVALID_BORROW", "借阅记录无效，无法提交续借申请");
        }

        if (v2Mapper.countBorrowCanRenew(borrowRecordId, readerId) <= 0) {
            return V2ActionResult.error("BORROW_NOT_ALLOWED", "该借阅记录不存在、已归还，或不属于当前读者");
        }

        if (v2Mapper.countPendingRenewRequest(borrowRecordId) > 0) {
            return V2ActionResult.error("RENEW_EXISTS", "该图书已有待审核续借申请，请勿重复提交");
        }

        v2Mapper.addRenewRequest(borrowRecordId, readerId, trim(reason));

        logOperation("READER", readerId, operatorName, "续借申请",
                "提交续借申请，借阅记录ID：" + borrowRecordId, requestUrl, ip);

        return V2ActionResult.success("续借申请已提交，请等待管理员审核");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult approveRenew(Integer id,
                                       Integer borrowRecordId,
                                       String remark,
                                       Integer handlerId,
                                       String handlerName,
                                       String requestUrl,
                                       String ip) {
        if (id == null || id <= 0 || borrowRecordId == null || borrowRecordId <= 0) {
            return V2ActionResult.error("INVALID_RENEW", "续借申请参数无效");
        }

        if (v2Mapper.countPendingRenewForBorrow(id, borrowRecordId) <= 0) {
            return V2ActionResult.error("RENEW_HANDLED", "该续借申请不存在、已被处理，或与借阅记录不匹配");
        }

        v2Mapper.approveRenew(id, handlerId, handlerName, trim(remark));
        v2Mapper.extendBorrowDueDate(borrowRecordId);
        v2Mapper.increaseBorrowRenewCount(borrowRecordId);

        logOperation("ADMIN", handlerId, handlerName, "续借审核",
                "通过续借申请ID：" + id + "，借阅记录ID：" + borrowRecordId, requestUrl, ip);

        return V2ActionResult.success("已通过续借申请，应还日期已顺延");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult rejectRenew(Integer id,
                                      String remark,
                                      Integer handlerId,
                                      String handlerName,
                                      String requestUrl,
                                      String ip) {
        if (id == null || id <= 0) {
            return V2ActionResult.error("INVALID_RENEW", "续借申请参数无效");
        }

        if (v2Mapper.countPendingRenewById(id) <= 0) {
            return V2ActionResult.error("RENEW_HANDLED", "该续借申请不存在或已被处理");
        }

        v2Mapper.rejectRenew(id, handlerId, handlerName, trim(remark));

        logOperation("ADMIN", handlerId, handlerName, "续借审核",
                "拒绝续借申请ID：" + id, requestUrl, ip);

        return V2ActionResult.success("已拒绝该续借申请");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult generateOverdueFines(Integer operatorId,
                                               String operatorName,
                                               String requestUrl,
                                               String ip) {
        int count = v2Mapper.generateOverdueFinesFinal();
        v2Mapper.syncBorrowFineStatus();

        logOperation("ADMIN", operatorId, operatorName, "罚款管理",
                "生成逾期罚款，新增记录数：" + count, requestUrl, ip);

        if (count > 0) {
            return V2ActionResult.success("已生成 " + count + " 条逾期罚款记录");
        }

        return V2ActionResult.success("当前没有新的逾期罚款需要生成");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult payFine(Integer id,
                                  Integer borrowRecordId,
                                  Integer operatorId,
                                  String operatorName,
                                  String requestUrl,
                                  String ip) {
        if (id == null || id <= 0 || borrowRecordId == null || borrowRecordId <= 0) {
            return V2ActionResult.error("INVALID_FINE", "罚款参数无效");
        }

        if (v2Mapper.countUnpaidFineForBorrow(id, borrowRecordId) <= 0) {
            return V2ActionResult.error("FINE_HANDLED", "该罚款不存在、已经缴费，或与借阅记录不匹配");
        }

        v2Mapper.markFinePaid(id, operatorId, operatorName);
        v2Mapper.updateBorrowFinePaid(borrowRecordId);

        logOperation("ADMIN", operatorId, operatorName, "罚款管理",
                "确认罚款缴费ID：" + id + "，借阅记录ID：" + borrowRecordId, requestUrl, ip);

        return V2ActionResult.success("罚款已确认缴费");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult reserveSeat(Integer seatId,
                                      Integer readerId,
                                      String reservationDate,
                                      Integer timeSlotId,
                                      String operatorName,
                                      String requestUrl,
                                      String ip) {
        if (readerId == null) {
            return V2ActionResult.error("NOT_LOGIN", "请先登录后再预约座位");
        }

        if (seatId == null || seatId <= 0) {
            return V2ActionResult.error("INVALID_SEAT", "请选择有效座位");
        }

        if (timeSlotId == null || timeSlotId <= 0) {
            return V2ActionResult.error("INVALID_SLOT", "请选择有效预约时段");
        }

        if (isBlank(reservationDate)) {
            return V2ActionResult.error("INVALID_DATE", "请选择预约日期");
        }

        v2Mapper.clearExpiredLocks();

        if (v2Mapper.countActiveSeat(seatId) <= 0) {
            return V2ActionResult.error("SEAT_NOT_FOUND", "该座位不存在或已停用");
        }

        if (v2Mapper.countPastSeatTimeSlot(reservationDate, timeSlotId) > 0) {
            return V2ActionResult.error("PAST_SLOT", "不能预约已经过去的日期或时段");
        }

        if (v2Mapper.countReaderSeatTimeReservation(readerId, reservationDate, timeSlotId) > 0) {
            return V2ActionResult.error("ONE_SLOT_ONE_SEAT", "同一日期、同一时段每位读者只能预约一个座位");
        }

        if (v2Mapper.countSeatConflict(seatId, reservationDate, timeSlotId) > 0) {
            return V2ActionResult.error("SEAT_OCCUPIED", "该座位已被预约或临时锁定，请选择其他座位");
        }

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 10);

        v2Mapper.lockSeat(seatId, readerId, reservationDate, timeSlotId, calendar.getTime());
        v2Mapper.createSeatReservation(seatId, readerId, reservationDate, timeSlotId);
        v2Mapper.releaseSeatLock(seatId, readerId, reservationDate, timeSlotId);

        logOperation("READER", readerId, operatorName, "座位预约",
                "预约座位ID：" + seatId + "，日期：" + reservationDate + "，时段ID：" + timeSlotId,
                requestUrl, ip);

        return V2ActionResult.success("座位预约成功");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult cancelOwnSeatReservation(Integer id,
                                                   Integer readerId,
                                                   String operatorName,
                                                   String requestUrl,
                                                   String ip) {
        if (id == null || id <= 0) {
            return V2ActionResult.error("INVALID_RESERVATION", "预约记录参数无效");
        }

        if (readerId == null) {
            return V2ActionResult.error("NOT_LOGIN", "请先登录后再取消预约");
        }

        int affected = v2Mapper.cancelOwnSeatReservation(id, readerId);
        if (affected <= 0) {
            return V2ActionResult.error("CANCEL_FAILED", "只能取消自己的有效预约");
        }

        logOperation("READER", readerId, operatorName, "座位预约",
                "取消自己的座位预约ID：" + id, requestUrl, ip);

        return V2ActionResult.success("预约已取消");
    }

    @Transactional(rollbackFor = Exception.class)
    public V2ActionResult cancelSeatReservationByAdmin(Integer id,
                                                       Integer operatorId,
                                                       String operatorName,
                                                       String requestUrl,
                                                       String ip) {
        if (id == null || id <= 0) {
            return V2ActionResult.error("INVALID_RESERVATION", "预约记录参数无效");
        }

        int affected = v2Mapper.cancelSeatReservation(id);
        if (affected <= 0) {
            return V2ActionResult.error("CANCEL_FAILED", "预约不存在或已取消");
        }

        logOperation("ADMIN", operatorId, operatorName, "座位管理",
                "管理员取消座位预约ID：" + id, requestUrl, ip);

        return V2ActionResult.success("预约已取消");
    }

    public void logOperation(String operatorType,
                             Integer operatorId,
                             String operatorName,
                             String module,
                             String operation,
                             String requestUrl,
                             String ip) {
        try {
            v2Mapper.addOperationLog(
                    emptyTo(operatorType, "UNKNOWN"),
                    operatorId,
                    emptyTo(operatorName, "未知用户"),
                    emptyTo(module, "系统"),
                    emptyTo(operation, "未知操作"),
                    emptyTo(requestUrl, ""),
                    emptyTo(ip, "")
            );
        } catch (Exception e) {
            System.out.println("[OPERATION LOG FAILED] " + e.getMessage());
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String emptyTo(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
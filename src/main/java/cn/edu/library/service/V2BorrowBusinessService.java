package cn.edu.library.service;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.entity.Admin;
import cn.edu.library.mapper.V2BorrowAdminMapper;
import cn.edu.library.util.V2AdminRoleUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 【本次修改】v2 借书、还书、上架中业务 Service。
 */
@Service
public class V2BorrowBusinessService {

    private static final int DEFAULT_BORROW_DAYS = 30;
    private static final int MAX_BORROW_DAYS = 180;
    private static final int MAX_ACTIVE_BORROWS = 5;

    @Resource
    private V2BorrowAdminMapper borrowAdminMapper;

    @Transactional
    public V2ActionResult borrowByCopyNo(String readerKey,
                                         String copyNo,
                                         Integer borrowDays,
                                         Admin admin,
                                         HttpServletRequest request) {
        if (admin == null) {
            return V2ActionResult.fail("登录已失效，请重新登录。");
        }

        String readerKeyword = safeTrim(readerKey);
        String normalizedCopyNo = safeTrim(copyNo);
        int days = normalizeBorrowDays(borrowDays);

        if (readerKeyword.length() == 0) {
            return V2ActionResult.fail("请输入读者编号、学号、用户名或姓名。");
        }
        if (normalizedCopyNo.length() == 0) {
            return V2ActionResult.fail("请输入图书实体编码。");
        }

        Map<String, Object> reader = borrowAdminMapper.findActiveReaderForBorrow(readerKeyword);
        if (reader == null) {
            return V2ActionResult.fail("读者不存在或已被禁用，不能办理借书。");
        }

        Integer readerId = toInt(reader.get("id"));
        String readerName = stringValue(reader.get("name"));

        if (borrowAdminMapper.countReaderUnpaidFines(readerId) > 0) {
            return V2ActionResult.fail("该读者存在未缴罚款，请处理后再办理借书。");
        }
        if (borrowAdminMapper.countReaderBorrowing(readerId) >= MAX_ACTIVE_BORROWS) {
            return V2ActionResult.fail("该读者当前借阅数量已达到上限 " + MAX_ACTIVE_BORROWS + " 本。");
        }

        Map<String, Object> copy = borrowAdminMapper.findCopyByCopyNo(normalizedCopyNo);
        if (copy == null) {
            return V2ActionResult.fail("图书实体编码不存在：" + normalizedCopyNo);
        }

        Integer copyId = toInt(copy.get("id"));
        Integer bookId = toInt(copy.get("bookId"));
        String bookName = stringValue(copy.get("bookName"));
        String shelfStatus = stringValue(copy.get("shelfStatus"));

        if (!"ON_SHELF".equals(shelfStatus)) {
            return V2ActionResult.fail("该图书当前状态为“" + translateShelfStatus(shelfStatus) + "”，不能借出。");
        }
        if (borrowAdminMapper.countReaderBorrowingSameBook(readerId, bookId) > 0) {
            return V2ActionResult.fail("该读者已借阅同一种图书，归还后才能再次借阅。");
        }

        borrowAdminMapper.insertBorrowRecord(readerId, bookId, copyId, normalizedCopyNo, admin.getId(), days);
        int changedCopy = borrowAdminMapper.markCopyBorrowed(copyId);
        if (changedCopy <= 0) {
            throw new IllegalStateException("图书状态已变化，请刷新后重试。");
        }
        borrowAdminMapper.decreaseBookAvailable(bookId);

        String message = "借阅成功：" + readerName + " 已借出《" + bookName + "》，实体编码 " + normalizedCopyNo + "，借阅天数 " + days + " 天。";
        log(admin, "BORROW", "BORROW_CREATE", message, request);
        return V2ActionResult.ok(message);
    }

    @Transactional
    public V2ActionResult returnByCopyNo(String copyNo, Admin admin, HttpServletRequest request) {
        if (admin == null) {
            return V2ActionResult.fail("登录已失效，请重新登录。");
        }

        String normalizedCopyNo = safeTrim(copyNo);
        if (normalizedCopyNo.length() == 0) {
            return V2ActionResult.fail("请输入要归还的图书实体编码。");
        }

        Map<String, Object> copy = borrowAdminMapper.findCopyByCopyNo(normalizedCopyNo);
        if (copy == null) {
            return V2ActionResult.fail("图书实体编码不存在：" + normalizedCopyNo);
        }

        String shelfStatus = stringValue(copy.get("shelfStatus"));
        if (!"BORROWED".equals(shelfStatus)) {
            return V2ActionResult.fail("该图书当前状态为“" + translateShelfStatus(shelfStatus) + "”，不能办理归还。");
        }

        Map<String, Object> borrow = borrowAdminMapper.findActiveBorrowByCopyNo(normalizedCopyNo);
        if (borrow == null) {
            return V2ActionResult.fail("未找到该实体书的未归还借阅记录，不能办理归还。");
        }

        Integer borrowId = toInt(borrow.get("id"));
        Integer copyId = toInt(borrow.get("copyId"));
        String bookName = stringValue(borrow.get("bookName"));
        String readerName = stringValue(borrow.get("readerName"));

        int changedBorrow = borrowAdminMapper.markBorrowReturned(borrowId, admin.getId());
        if (changedBorrow <= 0) {
            throw new IllegalStateException("借阅记录状态已变化，请刷新后重试。");
        }

        borrowAdminMapper.generateFineIfOverdue(borrowId);
        int changedCopy = borrowAdminMapper.markCopyReturnProcessing(copyId);
        if (changedCopy <= 0) {
            throw new IllegalStateException("图书实体状态已变化，请刷新后重试。");
        }

        String message = "归还成功：" + readerName + " 归还《" + bookName + "》，实体编码 " + normalizedCopyNo + "。该书已进入“上架中”，预计 2 天后自动恢复为“已上架”。";
        log(admin, "BORROW", "BORROW_RETURN", message, request);
        return V2ActionResult.ok(message);
    }

    @Transactional
    public V2ActionResult confirmShelf(Integer copyId, Admin admin, HttpServletRequest request) {
        if (admin == null) {
            return V2ActionResult.fail("登录已失效，请重新登录。");
        }
        if (copyId == null) {
            return V2ActionResult.fail("缺少图书实体 ID。");
        }

        Map<String, Object> copy = borrowAdminMapper.findCopyById(copyId);
        if (copy == null) {
            return V2ActionResult.fail("图书实体不存在。");
        }

        String shelfStatus = stringValue(copy.get("shelfStatus"));
        if (!"RETURN_PROCESSING".equals(shelfStatus)) {
            return V2ActionResult.fail("该图书当前状态不是“上架中”，不能确认上架。");
        }

        Integer bookId = toInt(copy.get("bookId"));
        String copyNo = stringValue(copy.get("copyNo"));

        int changed = borrowAdminMapper.markCopyOnShelf(copyId);
        if (changed <= 0) {
            throw new IllegalStateException("上架失败，图书状态可能已变化。");
        }
        borrowAdminMapper.increaseBookAvailable(bookId);
        borrowAdminMapper.markBorrowShelfConfirmed(copyId, admin.getId());

        String message = "上架成功：实体编码 " + copyNo + " 已恢复为“已上架”。";
        log(admin, "BORROW", "BOOK_SHELF_CONFIRM", message, request);
        return V2ActionResult.ok(message);
    }

    @Transactional
    public int autoShelfExpiredCopies(Admin admin, HttpServletRequest request) {
        List<Map<String, Object>> expired = borrowAdminMapper.listExpiredProcessingCopies();
        if (expired == null || expired.isEmpty()) {
            return 0;
        }

        int count = 0;
        for (Map<String, Object> copy : expired) {
            Integer copyId = toInt(copy.get("id"));
            Integer bookId = toInt(copy.get("bookId"));
            if (copyId == null || bookId == null) {
                continue;
            }
            int changed = borrowAdminMapper.markCopyOnShelf(copyId);
            if (changed > 0) {
                borrowAdminMapper.increaseBookAvailable(bookId);
                borrowAdminMapper.markBorrowShelfConfirmed(copyId, admin == null ? null : admin.getId());
                count++;
            }
        }

        if (count > 0 && admin != null) {
            log(admin, "BORROW", "BOOK_SHELF_AUTO", "自动上架完成：共处理 " + count + " 本上架中图书。", request);
        }
        return count;
    }

    private void log(Admin admin, String module, String operation, String message, HttpServletRequest request) {
        try {
            borrowAdminMapper.addOperationLog(
                    "ADMIN",
                    admin == null ? null : admin.getId(),
                    V2AdminRoleUtil.safeName(admin),
                    module,
                    operation + "：" + message,
                    request == null ? "" : request.getRequestURI(),
                    request == null ? "" : request.getRemoteAddr()
            );
        } catch (Exception ignored) {
            // 操作日志不能影响主业务。
        }
    }

    private int normalizeBorrowDays(Integer borrowDays) {
        if (borrowDays == null || borrowDays <= 0) {
            return DEFAULT_BORROW_DAYS;
        }
        return Math.min(borrowDays, MAX_BORROW_DAYS);
    }

    private String safeTrim(String text) {
        return text == null ? "" : text.trim();
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private Integer toInt(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return null;
        }
    }

    private String translateShelfStatus(String status) {
        if ("ON_SHELF".equals(status)) return "已上架";
        if ("BORROWED".equals(status)) return "借出中";
        if ("RETURN_PROCESSING".equals(status)) return "上架中";
        if ("OFF_SHELF".equals(status)) return "已下架";
        if ("DAMAGED".equals(status)) return "损坏";
        if ("LOST".equals(status)) return "遗失";
        return status == null || status.length() == 0 ? "未知" : status;
    }
}

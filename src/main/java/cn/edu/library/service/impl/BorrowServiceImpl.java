package cn.edu.library.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.edu.library.entity.Book;
import cn.edu.library.entity.BorrowRecord;
import cn.edu.library.entity.Reader;
import cn.edu.library.mapper.BookMapper; // 【本次修改】新增：用于处理 DECIMAL 类型的罚款金额
import cn.edu.library.mapper.BorrowMapper;
import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.service.BorrowService;

@Service
public class BorrowServiceImpl implements BorrowService {

    @Resource
    private BorrowMapper borrowMapper;

    @Resource
    private BookMapper bookMapper;

    @Resource
    private ReaderMapper readerMapper;

    @Override
    @Transactional
    public void borrowBook(Integer readerId, Integer bookId, Integer borrowDays) {
        if (borrowDays == null || borrowDays <= 0) {
            borrowDays = 30;
        }

        Reader reader = readerMapper.findById(readerId);
        if (reader == null || reader.getStatus() == null || reader.getStatus() != 1) {
            throw new RuntimeException("读者不存在或已被禁用");
        }

        Book book = bookMapper.findById(bookId);
        if (book == null || book.getStatus() == null || book.getStatus() != 1) {
            throw new RuntimeException("图书不存在或已下架");
        }

        if (book.getAvailableCount() == null || book.getAvailableCount() <= 0) {
            throw new RuntimeException("图书库存不足，无法借出");
        }

        if (borrowMapper.countBorrowingByReaderAndBook(readerId, bookId) > 0) {
            throw new RuntimeException("该读者已借阅此书且尚未归还");
        }

        Date now = new Date();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(now);
        calendar.add(Calendar.DAY_OF_MONTH, borrowDays);

        BorrowRecord record = new BorrowRecord();
        record.setReaderId(readerId);
        record.setBookId(bookId);
        record.setBorrowTime(now);
        record.setDueTime(calendar.getTime());

        borrowMapper.insert(record);

        int changed = bookMapper.decreaseAvailable(bookId);
        if (changed == 0) {
            throw new RuntimeException("库存扣减失败，请稍后重试");
        }
    }

    @Override
    @Transactional
    public void returnBook(Integer borrowId) {
        BorrowRecord record = borrowMapper.findById(borrowId);

        if (record == null) {
            throw new RuntimeException("借阅记录不存在");
        }

        if (!"BORROWED".equals(record.getStatus())) {
            throw new RuntimeException("该记录已归还，不能重复还书");
        }

        Date now = new Date();

        int overdueDays = 0;

        // 【本次修改】原来是 double fine = 0.0;
        // 【本次修改】现在 BorrowRecord.fine 是 BigDecimal，所以这里改为 BigDecimal.ZERO
        BigDecimal fine = BigDecimal.ZERO;

        String status = "RETURNED";

        if (record.getDueTime() != null && now.after(record.getDueTime())) {
            long diff = now.getTime() - record.getDueTime().getTime();
            overdueDays = (int) Math.ceil(diff / (1000.0 * 60 * 60 * 24));

            // 【本次修改】原来是 fine = overdueDays * 0.5;
            // 【本次修改】现在使用 BigDecimal 计算罚款，避免 double 转 BigDecimal 的编译错误
            fine = BigDecimal.valueOf(overdueDays).multiply(BigDecimal.valueOf(0.5));

            // 保留原来的状态值，避免影响当前已有 JSP 和 Mapper 逻辑
            status = "OVERDUE";
        }

        record.setReturnTime(now);
        record.setStatus(status);
        record.setOverdueDays(overdueDays);

        // 【本次修改】这里现在传入的是 BigDecimal，不再是 double
        record.setFine(fine);

        borrowMapper.returnBook(record);
        bookMapper.increaseAvailable(record.getBookId());
    }

    @Override
    public List<BorrowRecord> search(String keyword, String status) {
        return borrowMapper.search(keyword, status);
    }

    @Override
    public List<BorrowRecord> findByReaderId(Integer readerId) {
        return borrowMapper.findByReaderId(readerId);
    }
}
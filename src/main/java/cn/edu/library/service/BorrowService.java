package cn.edu.library.service;

import cn.edu.library.entity.BorrowRecord;
import java.util.List;

public interface BorrowService {
    void borrowBook(Integer readerId, Integer bookId, Integer borrowDays);
    void returnBook(Integer borrowId);
    List<BorrowRecord> search(String keyword, String status);
    List<BorrowRecord> findByReaderId(Integer readerId);
}

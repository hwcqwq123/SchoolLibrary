package cn.edu.library.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.edu.library.entity.Book;
import cn.edu.library.mapper.BookMapper;
import cn.edu.library.service.BookService;

@Service
public class BookServiceImpl implements BookService {

    @Resource
    private BookMapper bookMapper;

    @Override
    public Book findById(Integer id) {
        return bookMapper.findById(id);
    }

    /**
     * 【本次修改】返回类型改为 List<Book>
     */
    @Override
    public List<Book> search(String keyword, String category) {
        return bookMapper.search(keyword, category);
    }

    @Override
    public void save(Book book) {
        validateBook(book);

        // 新增图书时，可借库存默认等于总库存。
        if (book.getAvailableCount() == null) {
            book.setAvailableCount(book.getTotalCount());
        }

        // 【本次修改】新增字段默认值处理
        if (book.getBorrowCount() == null) {
            book.setBorrowCount(0);
        }
        if (book.getRecommendFlag() == null) {
            book.setRecommendFlag(0);
        }

        bookMapper.insert(book);
    }

    @Override
    public void update(Book book) {
        validateBook(book);

        if (book.getAvailableCount() == null) {
            book.setAvailableCount(book.getTotalCount());
        }

        bookMapper.update(book);
    }

    @Override
    public void delete(Integer id) {
        // 这里使用逻辑删除，避免借阅历史记录关联数据丢失。
        bookMapper.delete(id);
    }

    /**
     * 【本次修改】新增：图书基础校验，防止库存出现负数或可借数大于总库存
     */
    private void validateBook(Book book) {
        if (book == null) {
            throw new RuntimeException("图书信息不能为空");
        }

        if (book.getBookNo() == null || book.getBookNo().trim().length() == 0) {
            throw new RuntimeException("图书编号不能为空");
        }

        if (book.getBookName() == null || book.getBookName().trim().length() == 0) {
            throw new RuntimeException("书名不能为空");
        }

        if (book.getTotalCount() == null || book.getTotalCount() < 0) {
            throw new RuntimeException("总库存不能小于 0");
        }

        if (book.getAvailableCount() != null && book.getAvailableCount() < 0) {
            throw new RuntimeException("可借库存不能小于 0");
        }

        if (book.getAvailableCount() != null && book.getAvailableCount() > book.getTotalCount()) {
            throw new RuntimeException("可借库存不能大于总库存");
        }
    }
}
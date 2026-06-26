package cn.edu.library.service.impl;

import cn.edu.library.entity.Book;
import cn.edu.library.mapper.BookMapper;
import cn.edu.library.service.BookService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class BookServiceImpl implements BookService {
    @Resource
    private BookMapper bookMapper;

    @Override
    public Book findById(Integer id) {
        return bookMapper.findById(id);
    }

    @Override
    public List<Book> search(String keyword, String category) {
        return bookMapper.search(keyword, category);
    }

    @Override
    public void save(Book book) {
        // 新增图书时，可借库存默认等于总库存。
        if (book.getAvailableCount() == null) {
            book.setAvailableCount(book.getTotalCount());
        }
        bookMapper.insert(book);
    }

    @Override
    public void update(Book book) {
        bookMapper.update(book);
    }

    @Override
    public void delete(Integer id) {
        // 这里使用逻辑删除，避免借阅历史记录关联数据丢失。
        bookMapper.delete(id);
    }
}

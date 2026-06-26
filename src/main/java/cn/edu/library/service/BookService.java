package cn.edu.library.service;

import cn.edu.library.entity.Book;
import java.util.List;

public interface BookService {
    Book findById(Integer id);
    List<Book> search(String keyword, String category);
    void save(Book book);
    void update(Book book);
    void delete(Integer id);
}

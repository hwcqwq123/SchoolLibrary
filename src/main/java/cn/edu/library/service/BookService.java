package cn.edu.library.service;

import java.util.List;

import cn.edu.library.entity.Book;

public interface BookService {

    Book findById(Integer id);

    /**
     * 【本次修改】原来是原始 List，这里改成 List<Book>，类型更清晰
     */
    List<Book> search(String keyword, String category);

    void save(Book book);

    void update(Book book);

    void delete(Integer id);
}
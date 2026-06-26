package cn.edu.library.service;

import cn.edu.library.entity.Reader;
import java.util.List;

public interface ReaderService {
    Reader login(String readerNo, String password);
    Reader findById(Integer id);
    List<Reader> search(String keyword);
    void save(Reader reader);
    void update(Reader reader);
    void disable(Integer id);
    boolean changePassword(Integer readerId, String oldPassword, String newPassword);
}

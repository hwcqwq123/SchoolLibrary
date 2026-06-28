package cn.edu.library.service.impl;

import cn.edu.library.entity.Reader;
import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.service.ReaderService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 【本次修改】读者服务。
 *
 * 修复点：
 * 1. 登录统一走 ReaderMapper.login，SQL 中已限制 status = 1。
 * 2. 支持 username / reader_no / student_no 登录。
 * 3. 避免禁用读者仍可通过 findByReaderNo + 手动密码比对登录。
 */
@Service
public class ReaderServiceImpl implements ReaderService {

    @Resource
    private ReaderMapper readerMapper;

    @Override
    public Reader login(String username, String password) {
        if (isBlank(username) || password == null) {
            return null;
        }
        return readerMapper.login(username.trim(), password);
    }

    @Override
    public Reader findById(Integer id) {
        return readerMapper.findById(id);
    }

    @Override
    public List<Reader> search(String keyword) {
        return readerMapper.search(keyword);
    }

    @Override
    public void save(Reader reader) {
        reader.setUsername(reader.getReaderNo());
        reader.setPassword(Md5Util.md5("123456"));
        readerMapper.insert(reader);
    }

    @Override
    public void update(Reader reader) {
        readerMapper.update(reader);
    }

    @Override
    public void disable(Integer id) {
        readerMapper.disable(id);
    }

    @Override
    public boolean changePassword(Integer readerId, String oldPassword, String newPassword) {
        Reader reader = readerMapper.findById(readerId);
        if (reader == null || !reader.getPassword().equals(Md5Util.md5(oldPassword))) {
            return false;
        }
        return readerMapper.updatePassword(readerId, Md5Util.md5(newPassword)) > 0;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

package cn.edu.library.service.impl;

import cn.edu.library.entity.Reader;
import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.service.ReaderService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class ReaderServiceImpl implements ReaderService {
    @Resource
    private ReaderMapper readerMapper;

    @Override
    public Reader login(String readerNo, String password) {
        Reader reader = readerMapper.findByReaderNo(readerNo);
        if (reader == null) {
            return null;
        }
        return reader.getPassword().equals(Md5Util.md5(password)) ? reader : null;
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
        // 新增读者时，默认账号为 readerNo，默认密码为 123456。
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
}

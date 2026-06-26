package cn.edu.library.service.impl;

import cn.edu.library.entity.StatisticsVO;
import cn.edu.library.mapper.BookMapper;
import cn.edu.library.mapper.BorrowMapper;
import cn.edu.library.mapper.ReaderMapper;
import cn.edu.library.service.StatisticsService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

@Service
public class StatisticsServiceImpl implements StatisticsService {
    @Resource
    private BookMapper bookMapper;
    @Resource
    private ReaderMapper readerMapper;
    @Resource
    private BorrowMapper borrowMapper;

    @Override
    public StatisticsVO dashboard() {
        StatisticsVO vo = new StatisticsVO();
        vo.setBookCount(bookMapper.countAll());
        vo.setReaderCount(readerMapper.countAll());
        vo.setBorrowedCount(borrowMapper.countBorrowed());
        vo.setOverdueCount(borrowMapper.countOverdue());
        return vo;
    }
}

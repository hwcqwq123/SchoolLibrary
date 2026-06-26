package cn.edu.library.entity;

/**
 * 首页统计展示对象，不直接对应数据库表。
 */
public class StatisticsVO {
    private Integer bookCount;
    private Integer readerCount;
    private Integer borrowedCount;
    private Integer overdueCount;

    public Integer getBookCount() { return bookCount; }
    public void setBookCount(Integer bookCount) { this.bookCount = bookCount; }
    public Integer getReaderCount() { return readerCount; }
    public void setReaderCount(Integer readerCount) { this.readerCount = readerCount; }
    public Integer getBorrowedCount() { return borrowedCount; }
    public void setBorrowedCount(Integer borrowedCount) { this.borrowedCount = borrowedCount; }
    public Integer getOverdueCount() { return overdueCount; }
    public void setOverdueCount(Integer overdueCount) { this.overdueCount = overdueCount; }
}

package cn.edu.library.entity;

import java.util.Date;

/**
 * 借阅记录实体类，对应数据库 borrow_record 表。
 */
public class BorrowRecord {
    private Integer id;
    private Integer readerId;
    private Integer bookId;
    private Date borrowTime;
    private Date dueTime;
    private Date returnTime;
    /** 借阅状态：BORROWED=借阅中，RETURNED=已归还，OVERDUE=逾期归还 */
    private String status;
    private Integer overdueDays;
    private Double fine;
    private Date createTime;

    /** 以下字段来自关联查询，用于页面展示。 */
    private String readerNo;
    private String readerName;
    private String bookNo;
    private String bookName;
    private String category;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getReaderId() { return readerId; }
    public void setReaderId(Integer readerId) { this.readerId = readerId; }
    public Integer getBookId() { return bookId; }
    public void setBookId(Integer bookId) { this.bookId = bookId; }
    public Date getBorrowTime() { return borrowTime; }
    public void setBorrowTime(Date borrowTime) { this.borrowTime = borrowTime; }
    public Date getDueTime() { return dueTime; }
    public void setDueTime(Date dueTime) { this.dueTime = dueTime; }
    public Date getReturnTime() { return returnTime; }
    public void setReturnTime(Date returnTime) { this.returnTime = returnTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getOverdueDays() { return overdueDays; }
    public void setOverdueDays(Integer overdueDays) { this.overdueDays = overdueDays; }
    public Double getFine() { return fine; }
    public void setFine(Double fine) { this.fine = fine; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getReaderNo() { return readerNo; }
    public void setReaderNo(String readerNo) { this.readerNo = readerNo; }
    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }
    public String getBookNo() { return bookNo; }
    public void setBookNo(String bookNo) { this.bookNo = bookNo; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}

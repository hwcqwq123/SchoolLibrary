package cn.edu.library.entity;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 【本次新增】罚款记录实体类
 * 对应数据库表：fine_record
 */
public class FineRecord {

    private Integer id;
    private Integer borrowId;
    private Integer readerId;
    private Integer bookId;

    private Integer overdueDays;
    private BigDecimal amount;
    private String status;

    private Date payTime;
    private Integer operatorAdminId;
    private String remark;

    private Date createTime;
    private Date updateTime;

    /**
     * 【本次新增】扩展显示字段
     * 数据库中没有这些字段，后续 Mapper 通过关联查询得到
     */
    private String readerNo;
    private String readerName;
    private String bookNo;
    private String bookName;
    private String operatorAdminName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(Integer borrowId) {
        this.borrowId = borrowId;
    }
    
    public Integer getReaderId() {
        return readerId;
    }

    public void setReaderId(Integer readerId) {
        this.readerId = readerId;
    }
    
    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }
    
    public Integer getOverdueDays() {
        return overdueDays;
    }

    public void setOverdueDays(Integer overdueDays) {
        this.overdueDays = overdueDays;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getPayTime() {
        return payTime;
    }

    public void setPayTime(Date payTime) {
        this.payTime = payTime;
    }
    
    public Integer getOperatorAdminId() {
        return operatorAdminId;
    }

    public void setOperatorAdminId(Integer operatorAdminId) {
        this.operatorAdminId = operatorAdminId;
    }
    
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    
    public String getReaderNo() {
        return readerNo;
    }

    public void setReaderNo(String readerNo) {
        this.readerNo = readerNo;
    }
    
    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }
    
    public String getBookNo() {
        return bookNo;
    }

    public void setBookNo(String bookNo) {
        this.bookNo = bookNo;
    }
    
    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
    
    public String getOperatorAdminName() {
        return operatorAdminName;
    }

    public void setOperatorAdminName(String operatorAdminName) {
        this.operatorAdminName = operatorAdminName;
    }
}
package cn.edu.library.entity;

import java.util.Date;

/**
 * 【本次新增】续借申请实体类
 * 对应数据库表：renew_request
 */
public class RenewRequest {

    private Integer id;
    private Integer borrowId;
    private Integer readerId;
    private Integer bookId;

    private Date oldDueTime;
    private Date newDueTime;
    private String reason;

    private String status;
    private Date applyTime;

    private Integer auditAdminId;
    private Date auditTime;
    private String auditRemark;

    /**
     * 【本次新增】扩展显示字段
     * 数据库中没有这些字段，后续 Mapper 通过关联查询得到
     */
    private String readerNo;
    private String readerName;
    private String bookNo;
    private String bookName;
    private String auditAdminName;

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
    
    public Date getOldDueTime() {
        return oldDueTime;
    }

    public void setOldDueTime(Date oldDueTime) {
        this.oldDueTime = oldDueTime;
    }
    
    public Date getNewDueTime() {
        return newDueTime;
    }

    public void setNewDueTime(Date newDueTime) {
        this.newDueTime = newDueTime;
    }
    
    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }
    
    public Integer getAuditAdminId() {
        return auditAdminId;
    }

    public void setAuditAdminId(Integer auditAdminId) {
        this.auditAdminId = auditAdminId;
    }
    
    public Date getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(Date auditTime) {
        this.auditTime = auditTime;
    }
    
    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
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
    
    public String getAuditAdminName() {
        return auditAdminName;
    }

    public void setAuditAdminName(String auditAdminName) {
        this.auditAdminName = auditAdminName;
    }
}
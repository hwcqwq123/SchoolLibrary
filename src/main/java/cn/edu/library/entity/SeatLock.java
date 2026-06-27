package cn.edu.library.entity;

import java.util.Date;

/**
 * 【本次新增】座位临时锁定实体类
 * 对应数据库表：seat_lock
 *
 * 作用：
 * 用户点击某个座位后，系统先临时锁定 10 分钟。
 * 10 分钟内其他人不能预约这个座位。
 */
public class SeatLock {

    private Integer id;
    private Integer seatId;
    private Integer readerId;
    private Date reserveDate;
    private Integer slotId;
    private Date expireTime;
    private Integer activeKey;
    private Date createTime;

    /**
     * 【本次新增】扩展显示字段：座位编号
     * 数据库中没有该字段，后续 Mapper 通过关联 library_seat 表查询得到
     */
    private String seatNo;

    /**
     * 【本次新增】扩展显示字段：读者姓名
     * 数据库中没有该字段，后续 Mapper 通过关联 reader 表查询得到
     */
    private String readerName;

    /**
     * 【本次新增】扩展显示字段：时段名称
     * 数据库中没有该字段，后续 Mapper 通过关联 seat_time_slot 表查询得到
     */
    private String slotName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getSeatId() {
        return seatId;
    }

    public void setSeatId(Integer seatId) {
        this.seatId = seatId;
    }
    
    public Integer getReaderId() {
        return readerId;
    }

    public void setReaderId(Integer readerId) {
        this.readerId = readerId;
    }
    
    public Date getReserveDate() {
        return reserveDate;
    }

    public void setReserveDate(Date reserveDate) {
        this.reserveDate = reserveDate;
    }
    
    public Integer getSlotId() {
        return slotId;
    }

    public void setSlotId(Integer slotId) {
        this.slotId = slotId;
    }
    
    public Date getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Date expireTime) {
        this.expireTime = expireTime;
    }
    
    public Integer getActiveKey() {
        return activeKey;
    }

    public void setActiveKey(Integer activeKey) {
        this.activeKey = activeKey;
    }
    
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getSeatNo() {
        return seatNo;
    }

    public void setSeatNo(String seatNo) {
        this.seatNo = seatNo;
    }

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }

    public String getSlotName() {
        return slotName;
    }

    public void setSlotName(String slotName) {
        this.slotName = slotName;
    }
}
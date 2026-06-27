package cn.edu.library.entity;

import java.util.Date;

/**
 * 【本次新增】座位预约记录实体类
 * 对应数据库表：seat_reservation
 */
public class SeatReservation {

    private Integer id;
    private Integer seatId;
    private Integer readerId;
    private Date reserveDate;
    private Integer slotId;

    private String status;
    private Integer activeKey;

    private String cancelBy;
    private Integer cancelUserId;
    private Date cancelTime;
    private String cancelReason;

    private Date createTime;
    private Date updateTime;

    /**
     * 【本次新增】扩展显示字段：座位编号
     * 数据库中没有该字段，后续 Mapper 通过关联 library_seat 表查询得到
     */
    private String seatNo;

    /**
     * 【本次新增】扩展显示字段：楼层ID
     * 数据库中没有该字段，后续 Mapper 通过关联 library_seat 表查询得到
     */
    private Integer floorId;

    /**
     * 【本次新增】扩展显示字段：楼层名称
     * 数据库中没有该字段，后续 Mapper 通过关联 library_floor 表查询得到
     */
    private String floorName;

    /**
     * 【本次新增】扩展显示字段：读者编号
     * 数据库中没有该字段，后续 Mapper 通过关联 reader 表查询得到
     */
    private String readerNo;

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
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getActiveKey() {
        return activeKey;
    }

    public void setActiveKey(Integer activeKey) {
        this.activeKey = activeKey;
    }
    
    public String getCancelBy() {
        return cancelBy;
    }

    public void setCancelBy(String cancelBy) {
        this.cancelBy = cancelBy;
    }
    
    public Integer getCancelUserId() {
        return cancelUserId;
    }

    public void setCancelUserId(Integer cancelUserId) {
        this.cancelUserId = cancelUserId;
    }
    
    public Date getCancelTime() {
        return cancelTime;
    }

    public void setCancelTime(Date cancelTime) {
        this.cancelTime = cancelTime;
    }
    
    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
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

    public String getSeatNo() {
        return seatNo;
    }

    public void setSeatNo(String seatNo) {
        this.seatNo = seatNo;
    }

    public Integer getFloorId() {
        return floorId;
    }

    public void setFloorId(Integer floorId) {
        this.floorId = floorId;
    }

    public String getFloorName() {
        return floorName;
    }

    public void setFloorName(String floorName) {
        this.floorName = floorName;
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

    public String getSlotName() {
        return slotName;
    }

    public void setSlotName(String slotName) {
        this.slotName = slotName;
    }
}
package cn.edu.library.entity;

import java.util.Date;

/**
 * 【本次新增】图书馆楼层实体类
 * 对应数据库表：library_floor
 */
public class LibraryFloor {

    private Integer id;
    private Integer floorNo;
    private String floorName;
    private Integer seatCount;
    private Integer status;
    private Date createTime;
    private Date updateTime;

    /**
     * 【本次新增】扩展显示字段
     * 数据库中没有该字段，后续统计某楼层已预约座位数时使用
     */
    private Integer reservedCount;

    /**
     * 【本次新增】扩展显示字段
     * 数据库中没有该字段，后续统计某楼层可预约座位数时使用
     */
    private Integer availableCount;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFloorNo() {
        return floorNo;
    }

    public void setFloorNo(Integer floorNo) {
        this.floorNo = floorNo;
    }

    public String getFloorName() {
        return floorName;
    }

    public void setFloorName(String floorName) {
        this.floorName = floorName;
    }

    public Integer getSeatCount() {
        return seatCount;
    }

    public void setSeatCount(Integer seatCount) {
        this.seatCount = seatCount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public Integer getReservedCount() {
        return reservedCount;
    }

    public void setReservedCount(Integer reservedCount) {
        this.reservedCount = reservedCount;
    }

    public Integer getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(Integer availableCount) {
        this.availableCount = availableCount;
    }
}
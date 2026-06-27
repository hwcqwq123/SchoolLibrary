package cn.edu.library.entity;

/**
 * 【本次新增】座位状态展示 VO
 *
 * 说明：
 * 这个类不直接对应数据库表。
 * 后续用于读者端 10×10 可视化选座页面。
 */
public class SeatStatusVO {

    private Integer seatId;
    private String seatNo;
    private Integer rowNo;
    private Integer colNo;

    /**
     * 【本次新增】座位状态
     *
     * AVAILABLE：可预约，显示灰色
     * LOCKED_BY_ME：当前用户临时锁定，显示黄色
     * LOCKED_BY_OTHER：他人临时锁定，显示橙色或深灰色
     * RESERVED_BY_ME：当前用户已预约，显示绿色
     * RESERVED_BY_OTHER：他人已预约，显示红色
     * DISABLED：座位不可用，显示深灰色
     */
    private String status;

    /**
     * 【本次新增】预约记录ID
     * 当 status = RESERVED_BY_ME 时，读者取消自己的预约需要用到
     */
    private Integer reservationId;

    /**
     * 【本次新增】临时锁定剩余秒数
     * 当 status = LOCKED_BY_ME 时，用于前端显示倒计时
     */
    private Integer lockRemainSeconds;

    /**
     * 【本次新增】提示文本
     * 例如：可预约、已被预约、已锁定、我的预约
     */
    private String tip;

    public Integer getSeatId() {
        return seatId;
    }

    public void setSeatId(Integer seatId) {
        this.seatId = seatId;
    }

    public String getSeatNo() {
        return seatNo;
    }

    public void setSeatNo(String seatNo) {
        this.seatNo = seatNo;
    }

    public Integer getRowNo() {
        return rowNo;
    }

    public void setRowNo(Integer rowNo) {
        this.rowNo = rowNo;
    }

    public Integer getColNo() {
        return colNo;
    }

    public void setColNo(Integer colNo) {
        this.colNo = colNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public Integer getLockRemainSeconds() {
        return lockRemainSeconds;
    }

    public void setLockRemainSeconds(Integer lockRemainSeconds) {
        this.lockRemainSeconds = lockRemainSeconds;
    }

    public String getTip() {
        return tip;
    }

    public void setTip(String tip) {
        this.tip = tip;
    }
}
package cn.edu.library.entity;

import java.util.Date;

/**
 * 【本次新增】公告实体类
 * 对应数据库表：notice
 */
public class Notice {

    private Integer id;
    private String title;
    private String content;
    private Integer publisherId;
    private Integer status;
    private Date createTime;
    private Date updateTime;

    /**
     * 【本次新增】扩展显示字段：发布人名称
     * 数据库中没有该字段，后续 Mapper 通过关联 admin 表查询得到
     */
    private String publisherName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    
    public Integer getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(Integer publisherId) {
        this.publisherId = publisherId;
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
    
    public String getPublisherName() {
        return publisherName;
    }

    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }
}
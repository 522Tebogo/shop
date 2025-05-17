package com.work.work.entity;

import java.util.Date;

public class Invoice {
    @Override
    public String toString() {
        return "Invoice{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", invoiceNumber=" + invoiceNumber +
                ", orderCode=" + orderCode +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", taxNumber='" + taxNumber + '\'' +
                ", amount=" + amount +
                ", status=" + status +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }

    private int id;
    private String userName;
    private long invoiceNumber; // 发票号码
    private long orderCode;     // 关联的订单号
    private int userId;        // 用户ID
    private String title;      // 发票抬头
    private String taxNumber;  // 税号
    private double amount;     // 发票金额
    private int status;        // 状态：0-未开具，1-已开具，2-已删除
    private Date createTime;   // 创建时间
    private Date updateTime;   // 更新时间

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(long invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public long getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(long orderCode) {
        this.orderCode = orderCode;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTaxNumber() {
        return taxNumber;
    }

    public void setTaxNumber(String taxNumber) {
        this.taxNumber = taxNumber;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
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
}
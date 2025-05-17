package com.work.work.entity;

import lombok.Data;

import java.util.Date;

@Data // Lombok 注解，自动生成 getter, setter, toString 等
public class Order {
    private int id;
    private int userId;
    private long orderCode;
    private Double totalPrice;
    private Date createTime;
    private Integer addressId;  // 收货地址ID
    private String receiver;    // 收件人
    private String phone;       // 收件人电话
    private String address;
    private String status;
    private String userAccount; // <--- 新增这个属性
    private int payed;
    // 如果没有用 Lombok，你需要手动添加 getter 和 setter 方法:
    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    // 其他已有的 getter 和 setter 方法...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public long getOrderCode() { return orderCode; }
    public void setOrderCode(long orderCode) { this.orderCode = orderCode; }
    public Double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(Double totalPrice) { this.totalPrice = totalPrice; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
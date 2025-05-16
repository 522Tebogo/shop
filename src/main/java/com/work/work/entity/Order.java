package com.work.work.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Order {
    private  int id ;
    private  int userId;
    private long orderCode;
    private  Double totalPrice;
    private Date createTime;
    private int payed;
}

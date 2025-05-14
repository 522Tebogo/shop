package com.work.work.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Order {
    private  int id ;
    private  int userId;
    private  long order_code;
    private  Double totalPrice;
    private Date create_time;
}

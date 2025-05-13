package com.work.work.entity;

import lombok.Data;

@Data
public class Goods {
    private int id;
    private String name;
    private int NormalPrice;
    private int SurprisePrice;
    private String imageUrl;
    private String description;
    private int num;
}


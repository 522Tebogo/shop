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
    private String category;
    private int num;
    private  int stock;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNormalPrice() {
        return NormalPrice;
    }

    public void setNormalPrice(int normalPrice) {
        NormalPrice = normalPrice;
    }

    public int getSurprisePrice() {
        return SurprisePrice;
    }

    public void setSurprisePrice(int surprisePrice) {
        SurprisePrice = surprisePrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }
}


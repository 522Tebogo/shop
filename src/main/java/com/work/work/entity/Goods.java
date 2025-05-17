package com.work.work.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class Goods {
    private int id;
    private String name;
    // 这两个字段对应数据库截图中的 Goods 表
    private int NormalPrice;    // 对应数据库 NormalPrice
    private int SurprisePrice;  // 对应数据库 SurprisePrice
    private String imageUrl;    // 对应数据库 imageUrl
    private String description; // 对应数据库 description
    private String category;    // 对应数据库 category (VARCHAR) - 这是我们将使用的字段
    private int is_out;
    // 下面这些字段在截图的 Goods 表中目前不存在，但在 GoodMapper.xml 的 insertGoods 中被引用
    // 如果您的 Goods 表确实没有这些列，那么 insertGoods 语句需要调整
    private int num;            // 数据库中没有 num 列，除非您有其他用途
    private Integer categoryId; // 这个字段将不会被直接保存到 Goods 表的 category_id 列

    private BigDecimal salePrice;   // 数据库中没有 salePrice 列 (BigDecimal)
    private String no;              // 数据库中没有 no 列
    private BigDecimal marketPrice; // 数据库中没有 marketPrice 列 (BigDecimal)
    private Integer stock;          // 数据库中没有 stock 列
    private String image;           // 数据库中没有 image 列 (如果它和 imageUrl 不同的话)
    private String hottest;         // 数据库中没有 hottest 列
    private String newest;          // 数据库中没有 newest 列
    private Date saleTime;          // 数据库中没有 saleTime 列


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

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public BigDecimal getMarketPrice() {
        return marketPrice;
    }

    public void setMarketPrice(BigDecimal marketPrice) {
        this.marketPrice = marketPrice;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getHottest() {
        return hottest;
    }

    public void setHottest(String hottest) {
        this.hottest = hottest;
    }

    public String getNewest() {
        return newest;
    }

    public void setNewest(String newest) {
        this.newest = newest;
    }

    public Date getSaleTime() {
        return saleTime;
    }

    public void setSaleTime(Date saleTime) {
        this.saleTime = saleTime;
    }
}


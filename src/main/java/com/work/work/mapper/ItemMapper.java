package com.work.work.mapper;

import com.work.work.entity.Goods;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ItemMapper {

    Integer addGoodItem(int userid, int goodid, int num);
    List<Goods> getGoodsByUserId(int userId);
    List<Goods> isSingle(int userid,int goodid);
    void addNum(int userid, int goodid,int num);
    void updateQuantity(int userId, int goodId, int quantity);

}

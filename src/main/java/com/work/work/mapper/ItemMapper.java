package com.work.work.mapper;

import com.work.work.entity.Goods;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ItemMapper {

    Integer addGoodItem(int userid, int goodid, int num);
    Integer addGoodItems(int userid, int goodid, int num,long orderCode);
    List<Goods> getGoodsByUserId(int userId);
    List<Goods> isSingle(int userid,int goodid);
    void addNum(int userid, int goodid,int num);
    void updateQuantity(int userId, int goodId, int quantity);
    void updateQuantitys(int userId, int goodId, long orderCode,int quantity);
    int removeById(int userId, int goodId);
    List<Goods> getGoodsByUserIdTwo(long orderCode,int userId);
    Object getItemByCod(long orderCode);

}

package com.work.work.mapper;

import com.work.work.entity.Goods;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface GoodMapper {
    List<Goods> getRandomGoods();
    Goods getGoodById(int goodid);
    List<Goods> getAllGoods();
    List<Goods> getGoodsByCategory(String category);
    int getCountById(int goodid);
    int plusCount(int goodid,int num);
    int minusCount(int goodid,int num);
    int getCountByDoubleId(int userId ,int goodId);

    int getCountByTripleId(int userId ,int goodId,long orderCode);

}

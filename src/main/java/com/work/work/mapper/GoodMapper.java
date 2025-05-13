package com.work.work.mapper;

import com.work.work.entity.Goods;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GoodMapper {
    List<Goods> getRandomGoods();
    Goods getGoodById(int goodid);
}

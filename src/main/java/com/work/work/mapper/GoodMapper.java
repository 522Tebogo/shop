package com.work.work.mapper;

import com.work.work.entity.Goods;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GoodMapper {
    List<Goods> getRandomGoods();
    Goods getGoodById(int goodid);
    List<Goods> getAllGoods();
    List<Goods> getGoodsByCategory(String category);

    List<Goods> selectAll();
    List<Goods> selectHot();
    List<Goods> selectByPage(@Param("offset") int offset, @Param("pageSize") int
            pageSize, @Param("word") String word);
    long count(@Param("word") String word);
    int insertGoods(Goods goods); // 返回插入的行数
    int deleteGoodsById(@Param("id") int goodId); // 删除方法
    int getCountById(int goodid);
    int plusCount(int goodid,int num);
    int minusCount(int goodid,int num);
    int getCountByDoubleId(int userId ,int goodId);
    int getCountByTripleId(int userId ,int goodId,long orderCode);
    int changeCount(int goodid,int num);
    int getOutByGoodId(int goodid);

}

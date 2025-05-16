package com.work.work.service;

import com.work.work.entity.Goods;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface GoodService {
    List<Goods> getRandomGoods();
    Goods getGoodById(int goodid);
    List<Goods> getAllGoods();
    public List<Goods> getGoodsByCategory(String category);
    int getCountById(int goodid);
    int plusCount(int goodid,int num);
    int minusCount(int goodid,int num);
    int getCountByDoubleId(int userId ,int goodId);
    int getCountByTripleId(int userId ,int goodId,long orderCode);
    int changeCount(int goodid,int num);
    int getOutByGoodId(int goodid);
}

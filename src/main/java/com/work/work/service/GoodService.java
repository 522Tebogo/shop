package com.work.work.service;

import com.work.work.entity.Goods;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface GoodService {
    List<Goods> getRandomGoods();
    Goods getGoodById(int goodid);
    List<Goods> getAllGoods();
    public List<Goods> getGoodsByCategory(String category);

}

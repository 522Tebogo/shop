package com.work.work.service;

import com.work.work.entity.Goods;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface ItemService {

    Integer addGoodItem(int userid,int goodid,int num);
    List<Goods> getGoodsByUserId(int userId);
    List<Goods> isSingle(int userid,int goodid);
    void addNum(int userid, int goodid,int num);
    void updateQuantity(int userId, int goodId, int quantity);
    int removeById(int userId, int goodId);
}

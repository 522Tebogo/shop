package com.work.work.service.ServiceImpl;

import com.work.work.entity.Goods;
import com.work.work.mapper.ItemMapper;
import com.work.work.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ItemServiceImpl implements ItemService {
    @Autowired
    ItemMapper itemMapper;

    @Override
    public Integer addGoodItem(int userid, int goodid, int num) {
        return itemMapper.addGoodItem(userid,goodid,num);
    }

    @Override
    public Integer addGoodItems(int userid, int goodid, int num, long orderCode) {
        return itemMapper.addGoodItems(userid,goodid,num,orderCode);
    }

    @Override
    public List<Goods> getGoodsByUserId(int userId) {
        return itemMapper.getGoodsByUserId(userId);
    }

    @Override
    public List<Goods> isSingle(int userid, int goodid) {
        return itemMapper.isSingle(userid,goodid);
    }

    @Override
    public void addNum(int userid, int goodid,int num) {
        itemMapper.addNum(userid,goodid,num);
    }

    @Override
    public void updateQuantity(int userId, int goodId, int quantity) {
        itemMapper.updateQuantity(userId, goodId, quantity);
    }

    @Override
    public int removeById(int userId, int goodId) {
        return itemMapper.removeById(userId,goodId);
    }

    @Override
    public List<Goods> getGoodsByUserIdTwo(long orderCode,int userId) {
        return itemMapper.getGoodsByUserIdTwo(orderCode,userId);
    }

    @Override
    public Object getItemByCod(long orderCode) {
        return itemMapper.getItemByCod(orderCode);
    }

}

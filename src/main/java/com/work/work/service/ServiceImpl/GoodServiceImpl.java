package com.work.work.service.ServiceImpl;

import com.work.work.entity.Goods;
import com.work.work.mapper.GoodMapper;
import com.work.work.service.GoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoodServiceImpl implements GoodService {
    @Autowired
    GoodMapper goodMapper;
    @Override
    public List<Goods> getRandomGoods() {
        return goodMapper.getRandomGoods();
    }

    @Override
    public Goods getGoodById(int goodid) {
        return goodMapper.getGoodById(goodid);
    }

    @Override
    public List<Goods> getAllGoods() {
        return goodMapper.getAllGoods();
    }
    @Override
    public List<Goods> getGoodsByCategory(String category) {
        return goodMapper.getGoodsByCategory(category);
    }

    @Override
    public int getCountById(int goodid) {
        return goodMapper.getCountById(goodid);
    }

    @Override
    public int plusCount(int goodid, int num) {
        return goodMapper.plusCount(goodid, num);
    }

    @Override
    public int minusCount(int goodid, int num) {
        return goodMapper.minusCount(goodid, num);
    }

    @Override
    public int getCountByDoubleId(int userId, int goodId) {
        return goodMapper.getCountByDoubleId(userId,goodId);
    }



    @Override
    public int getCountByTripleId(int userId, int goodId, long orderCode) {
        return goodMapper.getCountByTripleId(userId,goodId,orderCode);
    }

    @Override
    public int changeCount(int goodid, int num) {
        return goodMapper.changeCount(goodid,num);
    }

    @Override
    public int getOutByGoodId(int goodid) {
        return goodMapper.getOutByGoodId(goodid);
    }


}

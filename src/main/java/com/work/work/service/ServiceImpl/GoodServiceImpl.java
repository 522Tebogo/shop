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

}

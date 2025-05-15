package com.work.work.mapper;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderMapper {
    int insertOrder(Order order);
    int insertCode(long orderCode,int userId);
    List<Order> getOrderListByUserId(int userId);
    List<Goods> getGoodsByOrderCode(long orderCode);
    Order getOrderByOrderCode(long orderCode);
}

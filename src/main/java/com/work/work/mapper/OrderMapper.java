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
    int deleteOrderAndItems(long orderCode,int userId);
    int updateCarItemQuantity(int userId,int goodId,long orderCode,int quantity);
    int updateOrderTotalPrice(long orderCode,double totalPrice);
    List<Integer> getGoodIdByCode(long orderCode);
    int getCodeNum(int userid ,int goodid, long orderCode);
    int getPriceByCode(long orderCode);
    void setPayed(long orderCode);
}

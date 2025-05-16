package com.work.work.service.ServiceImpl;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import com.work.work.mapper.OrderMapper;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private OrderMapper orderMapper;

    @Override
    public boolean createOrder(int userId, double totalPrice, long orderCode, HttpSession session) {
        System.out.println("用户id:"+userId);
        System.out.println("总金额:"+totalPrice);
        System.out.println("订单号:"+orderCode);
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderCode(orderCode);

        return orderMapper.insertOrder(order) > 0 && orderMapper.insertCode(orderCode,userId) > 0;
    }

    @Override
    public List<Order> getOrderListByUserId(int userId) {
        return orderMapper.getOrderListByUserId(userId);
    }

    @Override
    public List<Goods> getGoodsByOrderCode(long orderCode) {
        return orderMapper.getGoodsByOrderCode(orderCode);
    }

    @Override
    public Order getOrderByOrderCode(long orderCode) {
        return orderMapper.getOrderByOrderCode(orderCode);
    }

    @Override
    public boolean deleteOrderByCode(long orderCode, int userId) {
        System.out.println(orderCode+":"+userId);
        return  orderMapper.deleteOrderAndItems(orderCode,userId) > 0;
    }
    @Override
    public void updateOrder(long orderCode, int userId, List<Integer> goodsIds, List<Integer> quantities) {
        // 遍历商品ID和数量，更新购物车数量
        for (int i = 0; i < goodsIds.size(); i++) {
            int goodId = goodsIds.get(i);
            int quantity = quantities.get(i);
            System.out.println("userId:"+userId+",goodId:"+goodId+",quantity:"+quantity);
            orderMapper.updateCarItemQuantity(userId, goodId, orderCode, quantity);
        }

        // 重新计算订单总价
        List<Goods> goodsList = orderMapper.getGoodsByOrderCode(orderCode);
        double totalPrice = 0;
        for (Goods g : goodsList) {
            totalPrice += g.getSurprisePrice() * g.getNum()+(g.getSurprisePrice() * g.getNum())*0.02;
        }

        // 更新订单总价
        orderMapper.updateOrderTotalPrice(orderCode, totalPrice);
    }

    @Override
    public List<Integer> getGoodIdByCode(long orderCode) {
        return orderMapper.getGoodIdByCode(orderCode);
    }

    @Override
    public int getCodeNum(int userid, int goodid, long orderCode) {
        return orderMapper.getCodeNum(userid,goodid,orderCode);
    }


}

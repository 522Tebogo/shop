package com.work.work.service;

import com.work.work.entity.Address;
import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

import java.util.List;

@Service // @Service 注解通常放在实现类上，接口上可以不加，但加了也无害
public interface OrderService {
    boolean createOrder(int userId, double totalPrice, long orderCode, Address address, HttpSession session);
    List<Order> getOrderListByUserId(int userId);
    List<Goods> getGoodsByOrderCode(long orderCode);
    Order getOrderByOrderCode(long orderCode);
    boolean deleteOrderByCode(long orderCode,int userId);
    void updateOrder(long orderCode, int userId, List<Integer> goodsIds, List<Integer> quantities);
    List<Integer> getGoodIdByCode(long orderCode);
    int getCodeNum(int userid ,int goodid, long orderCode);

    // --- 管理员订单管理方法 ---
    List<Order> getAllOrdersForAdmin(); // 获取所有订单供管理员使用
    boolean markOrderAsShipped(long orderCode); // 标记订单为已发货
    String payOrder(int userId, long orderCode, HttpSession session);
    void orderSuccess(int userId,long orderCode );
    void setPayed(long orderCode);
}
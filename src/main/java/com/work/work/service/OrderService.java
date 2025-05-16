package com.work.work.service;

import com.work.work.entity.Address;
import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface OrderService {
    boolean createOrder(int userId, double totalPrice, long orderCode, HttpSession session);
    boolean createOrder(int userId, double totalPrice, long orderCode, Address address, HttpSession session);
    List<Order> getOrderListByUserId(int userId);
    List<Goods> getGoodsByOrderCode(long orderCode);
    Order getOrderByOrderCode(long orderCode);
    boolean deleteOrderByCode(long orderCode,int userId);
    void updateOrder(long orderCode, int userId, List<Integer> goodsIds, List<Integer> quantities);
    List<Integer> getGoodIdByCode(long orderCode);
    int getCodeNum(int userid ,int goodid, long orderCode);
    boolean updateOrderAddress(long orderCode, Integer addressId, String receiver, String phone, String address);
    String payOrder(int userId, long orderCode, HttpSession session);

    void orderSuccess(int userId,long orderCode );
    void setPayed(long orderCode);
}

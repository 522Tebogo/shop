package com.work.work.service;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface OrderService {
    boolean createOrder(int userId, double totalPrice, long orderCode, HttpSession session);
    List<Order> getOrderListByUserId(int userId);
    List<Goods> getGoodsByOrderCode(long orderCode);
    Order getOrderByOrderCode(long orderCode);
}

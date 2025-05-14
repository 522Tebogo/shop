package com.work.work.service.ServiceImpl;

import com.work.work.entity.Order;
import com.work.work.mapper.OrderMapper;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
        order.setOrder_code(orderCode);

        return orderMapper.insertOrder(order) > 0 && orderMapper.insertCode(orderCode,userId) > 0;
    }
}

package com.work.work.service;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

@Service
public interface OrderService {
    boolean createOrder(int userId, double totalPrice, long orderCode, HttpSession session);

}

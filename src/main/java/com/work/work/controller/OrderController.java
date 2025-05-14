package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.User;
import com.work.work.service.ItemService;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    ItemService itemService;
    @GetMapping("/toOrder")
    public String toOrder(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Goods> goods = itemService.getGoodsByUserId(user.getId());
        model.addAttribute("goods", goods);
        return "order_sure";
    }

    @Autowired
    private OrderService orderService;

    // 提交订单
    @PostMapping("/submit")
    public String submitOrder(HttpSession session,
                              @RequestParam("userId") int userId,
                              @RequestParam("totalPrice") double totalPrice,
                              @RequestParam("orderCode") long orderCode,
                              Model model) {
        // 保存订单
        boolean success = orderService.createOrder(userId, totalPrice, orderCode,session);

        if (success) {
            return "order_add";
        }
        return "order_sure"; // 返回确认订单页面
    }

}

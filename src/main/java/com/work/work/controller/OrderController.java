package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            Order order = orderService.getOrderByOrderCode(orderCode);
            model.addAttribute("order", order);
            return "order_add";
        }
        return "order_sure"; // 返回确认订单页面
    }

    @GetMapping("/getOrder")
    public String getOrder(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        List<Order> orderList = orderService.getOrderListByUserId(userId);

        // 为每个订单设置商品列表（可用Map或者给Order加个属性）
        Map<Long, List<Goods>> orderGoodsMap = new HashMap<>();
        for (Order order : orderList) {
            List<Goods> goodsList = orderService.getGoodsByOrderCode(order.getOrderCode());
            orderGoodsMap.put(order.getOrderCode(), goodsList);
        }

        System.out.println("这是订单信息:"+orderList);
        System.out.println("这是详情:"+orderGoodsMap);
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderGoodsMap", orderGoodsMap);
        return "order_list";
    }

}

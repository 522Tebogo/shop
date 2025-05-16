package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import com.work.work.entity.User;
import com.work.work.service.GoodService;
import com.work.work.service.ItemService;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    GoodService goodService;
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
        System.out.println("到了确认controller");
        boolean success = orderService.createOrder(userId, totalPrice, orderCode,session);

        if (success) {
            Order order = orderService.getOrderByOrderCode(orderCode);
            model.addAttribute("order", order);
            return "order_add";
        }
        return "order_sure"; // 返回确认订单页面
    }
    // 提交订单


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




    @GetMapping("/delete/{orderCode}")
    public String deleteOrderByCode(HttpSession session, @PathVariable("orderCode") long orderCode,Model model) {
        System.out.println("删除中");
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        List<Integer> kk  = orderService.getGoodIdByCode(orderCode);
        System.out.println("数字列表:"+kk);
        for(Integer i : kk ){
            int temp =orderService.getCodeNum(userId,i,orderCode);
            System.out.println("数量:"+temp);
            System.out.println("当前商品id:"+i+",当前数量为:"+goodService.getCountById(i));
            int z= goodService.plusCount(i,temp);
            System.out.println("当前商品id:"+i+",当前数量为:"+goodService.getCountById(i));

        }
        boolean res = orderService.deleteOrderByCode(orderCode, userId);
        if (res) {
            List<Order> orderList = orderService.getOrderListByUserId(userId);

            // 为每个订单设置商品列表（可用Map或者给Order加个属性）
            Map<Long, List<Goods>> orderGoodsMap = new HashMap<>();
            for (Order order : orderList) {
                List<Goods> goodsList = orderService.getGoodsByOrderCode(order.getOrderCode());
                orderGoodsMap.put(order.getOrderCode(), goodsList);
            }
            model.addAttribute("orderList", orderList);
            model.addAttribute("orderGoodsMap", orderGoodsMap);
            System.out.println("删除成功");
            return "order_list";
        }
        else {
            System.out.println("删除失败");
            return "order_list";
        }

    }
    @GetMapping("/edit/{orderCode}")
    public String showEditPage(@PathVariable(name =  "orderCode") long orderCode, Model model) {
        List<Goods> goods = orderService.getGoodsByOrderCode(orderCode);
        model.addAttribute("goods", goods);
        model.addAttribute("orderCode", orderCode);
        return "order_edit"; // 你的 JSP 页面名
    }

    @PostMapping("/update")
    public String updateOrder(@RequestParam("orderCode") long orderCode,
                              @RequestParam("goodsId") List<Integer> goodsIds,
                              @RequestParam("nums") List<Integer> nums,
                              HttpSession session,Model model) {

        System.out.println("商品数量:"+nums);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        // 调用服务层更新购物车和订单信息
        orderService.updateOrder(orderCode, userId, goodsIds, nums);
        System.out.println("更新成功");
        List<Order> orderList = orderService.getOrderListByUserId(userId);

        // 为每个订单设置商品列表（可用Map或者给Order加个属性）
        Map<Long, List<Goods>> orderGoodsMap = new HashMap<>();
        for (Order order : orderList) {
            List<Goods> goodsList = orderService.getGoodsByOrderCode(order.getOrderCode());
            orderGoodsMap.put(order.getOrderCode(), goodsList);
        }
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderGoodsMap", orderGoodsMap);
        // 更新成功后跳转到订单列表页
        return "order_list";
    }


}

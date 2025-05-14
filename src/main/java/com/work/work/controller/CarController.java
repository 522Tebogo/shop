package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.User;
import com.work.work.service.ItemService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/car")
public class CarController {
    @Autowired
    ItemService itemService;

    @GetMapping("/toCar")
    public String toCar(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Goods> goods = itemService.getGoodsByUserId(user.getId());
        System.out.println("这是购物车信息:"+goods);
        model.addAttribute("goods", goods);
        return "car";
    }

    @PostMapping("/add")
    public String add(@RequestParam("goodId") int goodid, @RequestParam("quantity") int num, HttpSession session,Model model) {
        User user = (User) session.getAttribute("user");
        int userid = user.getId();
        boolean isEmpty = this.isSingle(userid,goodid);
        if(isEmpty==true) {
            int res = itemService.addGoodItem(userid, goodid, num);
            if (res == 1) {
                System.out.println("添加成功");
                List<Goods> goods = itemService.getGoodsByUserId(user.getId());

                model.addAttribute("goods", goods);

                return "car";
            } else {
                System.out.println("添加失败");
                return "";
            }
        }
        else{
            itemService.addNum(userid,goodid,num);
            List<Goods> goods = itemService.getGoodsByUserId(user.getId());
            model.addAttribute("goods", goods);
            return "car";
        }

    }

    public boolean isSingle(int userid,int goodid) {
        List<Goods> goods = itemService.isSingle(userid,goodid);
        if (goods.size()>0) {
            return false;
        }
        else
            return true;
    }
    @PostMapping("/updateQuantity")
    @ResponseBody
    public Map<String, Object> updateQuantity(@RequestBody Map<String, Integer> requestData, HttpSession session) {
        int goodId = requestData.get("goodId");
        int quantity = requestData.get("quantity");
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // 更新数据库中的商品数量
        itemService.updateQuantity(userId, goodId, quantity);

        // 获取更新后的购物车商品列表
        List<Goods> updatedGoods = itemService.getGoodsByUserId(userId);

        // 返回更新后的数据
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("updatedGoods", updatedGoods);
        return response;
    }

}
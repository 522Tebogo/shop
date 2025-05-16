package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.User;
import com.work.work.service.GoodService;
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
    GoodService goodService;
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
    public String add(@RequestParam("goodId") int goodId, @RequestParam("quantity") int num,  HttpSession session,Model model) {
        String  msg = null;
        User user = (User) session.getAttribute("user");
             int count = goodService.getCountById(goodId);
             int out = goodService.getOutByGoodId(goodId);
             if(out==1){
                 model.addAttribute("msg","抱歉，该商品已下架，去看看别的商品吧");
                 Goods good = goodService.getGoodById(goodId);
                 model.addAttribute("good", good);
                 return "single_info";
             }
             if(count < num){
                 System.out.println("库存不足，无法出货！");
                 model.addAttribute("msg","库存不足，无法出货");
                 Goods good = goodService.getGoodById(goodId);
                 model.addAttribute("good", good);
                 return "single_info";
             }
            if(user ==null)
            {
                return "login";
            }

            int userid = user.getId();
            boolean isEmpty = this.isSingle(userid,goodId);
            if(isEmpty==true) {
                int res = itemService.addGoodItem(userid, goodId, num);
                if (res == 1) {
                    System.out.println("添加成功");
                    List<Goods> goods = itemService.getGoodsByUserId(user.getId());
                    System.out.println("拿到的商品信息:"+goods);
                    model.addAttribute("goods", goods);
                    int mark =goodService.minusCount(goodId,num);
                    return "car";
                } else {
                    System.out.println("添加失败");
                    return "";
                }
            }
            else{
                    itemService.addNum(userid,goodId,num);
                List<Goods> goods = itemService.getGoodsByUserId(user.getId());
                model.addAttribute("goods", goods);

                int mark =goodService.minusCount(goodId,num);
                return "car";
            }

        }

        public boolean isSingle(int userid,int goodId) {
                List<Goods> goods = itemService.isSingle(userid,goodId);
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
        int number = goodService.getCountByDoubleId(userId,goodId);
        int stock = goodService.getCountById(goodId);
        if(quantity>stock+number){
            List<Goods> updatedGoods = itemService.getGoodsByUserId(userId);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("updatedGoods", updatedGoods);
            return response;
        }

        int changeNum = number - quantity;
        // 更新数据库中的商品数量
        itemService.updateQuantity(userId, goodId, quantity);
        int r=goodService.changeCount(goodId,changeNum);
        // 获取更新后的购物车商品列表
        List<Goods> updatedGoods = itemService.getGoodsByUserId(userId);

        // 返回更新后的数据
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("updatedGoods", updatedGoods);
        return response;
    }
    @PostMapping("/updateQuantityTwo")
    @ResponseBody
    public Map<String, Object> updateQuantityTwo(@RequestBody Map<String, Object> requestData, HttpSession session) {

        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        int goodId = Integer.parseInt(requestData.get("goodId").toString());
        int quantity = Integer.parseInt(requestData.get("quantity").toString());
        Long orderCode = Long.parseLong(requestData.get("orderCode").toString());
        int number = goodService.getCountByTripleId(userId,goodId,orderCode);
        int stock = goodService.getCountById(goodId);
        System.out.println("orderCode在这里:"+orderCode);
        if(quantity>stock+number){
            List<Goods> updatedGoods = itemService.getGoodsByUserId(userId);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("updatedGoods", updatedGoods);
            return response;
        }
        int changeNum = number - quantity;
        // 更新数据库中的商品数量
        itemService.updateQuantity(userId, goodId, quantity);
        int r=goodService.changeCount(goodId,changeNum);
        // 更新数据库中的商品数量


        // 获取更新后的购物车商品列表
        List<Goods> updatedGoods = itemService.getGoodsByUserIdTwo(orderCode,userId);
        System.out.println("商品列表:"+updatedGoods);
        // 返回更新后的数据
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("updatedGoods", updatedGoods);
        return response;
    }
    @GetMapping("/remove/{goodId}")
    public String remove(@PathVariable("goodId") int goodId, HttpSession session,Model model) {
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        System.out.println("用户id:"+userId);
        System.out.println("商品id："+goodId);
        int mark = goodService.getCountByDoubleId(userId,goodId);
        System.out.println("mark:"+mark);
        int Success = itemService.removeById(userId,goodId);
        if(Success==1) {
            System.out.println("删除成功");
            List<Goods> goods = itemService.getGoodsByUserId(userId);
            int res = goodService.plusCount(goodId,mark);
            model.addAttribute("goods", goods);
            return "car";
        }
        else{
            System.out.println("失败");
            return "car";
        }
    }
}
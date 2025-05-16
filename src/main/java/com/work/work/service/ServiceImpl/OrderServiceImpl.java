package com.work.work.service.ServiceImpl;

import com.work.work.entity.Address;
import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import com.work.work.mapper.OrderMapper;
import com.work.work.service.ItemService;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    AlipayService alipayService;
    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    ItemService itemService;
    @Override
    public boolean createOrder(int userId, double totalPrice, long orderCode, HttpSession session) {
        System.out.println("用户id:"+userId);
        System.out.println("总金额:"+totalPrice);
        System.out.println("订单号:"+orderCode);
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderCode(orderCode);

        return orderMapper.insertOrder(order) > 0 && orderMapper.insertCode(orderCode,userId) > 0;
    }
    
    @Override
    public boolean createOrder(int userId, double totalPrice, long orderCode, Address address, HttpSession session) {
        System.out.println("用户id:" + userId);
        System.out.println("总金额:" + totalPrice);
        System.out.println("订单号:" + orderCode);
        
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderCode(orderCode);
        
        // 设置地址信息
        if (address != null) {
            order.setAddressId(address.getId());
            order.setReceiver(address.getReceiver());
            order.setPhone(address.getPhone());
            String fullAddress = address.getProvince() + address.getCity() + 
                                address.getDistrict() + address.getDetailAddress();
            order.setAddress(fullAddress);
        }

        return orderMapper.insertOrder(order) > 0 && orderMapper.insertCode(orderCode, userId) > 0;
    }

    @Override
    public List<Order> getOrderListByUserId(int userId) {
        return orderMapper.getOrderListByUserId(userId);
    }

    @Override
    public List<Goods> getGoodsByOrderCode(long orderCode) {
        return orderMapper.getGoodsByOrderCode(orderCode);
    }

    @Override
    public Order getOrderByOrderCode(long orderCode) {
        return orderMapper.getOrderByOrderCode(orderCode);
    }

    @Override
    public boolean deleteOrderByCode(long orderCode, int userId) {
        System.out.println(orderCode+":"+userId);
        return  orderMapper.deleteOrderAndItems(orderCode,userId) > 0;
    }
    @Override
    public void updateOrder(long orderCode, int userId, List<Integer> goodsIds, List<Integer> quantities) {
        // 遍历商品ID和数量，更新购物车数量
        for (int i = 0; i < goodsIds.size(); i++) {
            int goodId = goodsIds.get(i);
            int quantity = quantities.get(i);
            System.out.println("userId:"+userId+",goodId:"+goodId+",quantity:"+quantity);
            orderMapper.updateCarItemQuantity(userId, goodId, orderCode, quantity);
        }

        // 重新计算订单总价
        List<Goods> goodsList = orderMapper.getGoodsByOrderCode(orderCode);
        double totalPrice = 0;
        for (Goods g : goodsList) {
            totalPrice += g.getSurprisePrice() * g.getNum()+(g.getSurprisePrice() * g.getNum())*0.02;
        }

        // 更新订单总价
        orderMapper.updateOrderTotalPrice(orderCode, totalPrice);
    }

    @Override
    public List<Integer> getGoodIdByCode(long orderCode) {
        return orderMapper.getGoodIdByCode(orderCode);
    }

    @Override
    public int getCodeNum(int userid, int goodid, long orderCode) {
        return orderMapper.getCodeNum(userid,goodid,orderCode);
    }

    @Override
    public boolean updateOrderAddress(long orderCode, Integer addressId, String receiver, String phone, String address) {
        return orderMapper.updateOrderAddress(orderCode, addressId, receiver, phone, address) > 0;
    }

    @Transactional
    public String payOrder(int userId, long orderCode,HttpSession session) {
        System.out.println("到了页面处理");
        //1.购物车里是否有数据
        List<Goods> cartItems = itemService.getGoodsByUserIdTwo(orderCode,userId);
        System.out.println("购物车信息:"+cartItems);
        if (cartItems == null || cartItems.isEmpty()) return null;

        //获取支付金额
        int totalMoney = orderMapper.getPriceByCode(orderCode);
        //接入支付宝：
        String form = alipayService.createPayment(orderCode, ""+totalMoney, "支付订单:"+orderCode);
        //保存订单id
        session.setAttribute("orderCode",orderCode);

        return form;
    }

    @Override
    public void orderSuccess(int userid ,long orderCode) {
        orderMapper.setPayed(orderCode);
    }

    @Override
    public void setPayed(long orderCode) {
        orderMapper.setPayed(orderCode);
    }

}

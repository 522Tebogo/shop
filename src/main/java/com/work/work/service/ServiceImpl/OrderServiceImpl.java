package com.work.work.service.ServiceImpl;

import com.work.work.entity.Address;
import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import com.work.work.mapper.OrderMapper;
import com.work.work.service.ItemService;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    private static final Logger logger = LoggerFactory.getLogger(OrderServiceImpl.class);

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_SHIPPED = "SHIPPED";
    public static final String STATUS_DELIVERED = "DELIVERED";
    public static final String STATUS_CANCELED = "CANCELED";

    @Autowired
    AlipayService alipayService;
    @Autowired
    ItemService itemService;
    @Autowired
    private OrderMapper orderMapper;

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
        logger.debug("Fetching order list for userId: {}", userId);
        return orderMapper.getOrderListByUserId(userId);
    }

    @Override
    public List<Goods> getGoodsByOrderCode(long orderCode) {
        logger.debug("Fetching goods for orderCode: {}", orderCode);
        return orderMapper.getGoodsByOrderCode(orderCode);
    }

    @Override
    public Order getOrderByOrderCode(long orderCode) {
        logger.debug("Fetching order details for orderCode: {}", orderCode);
        return orderMapper.getOrderByOrderCode(orderCode);
    }

    @Override
    @Transactional
    public boolean deleteOrderByCode(long orderCode, int userId) {
        logger.info("Attempting to delete order {} for userId: {}", orderCode, userId);
        Order orderToDelete = orderMapper.getOrderByOrderCode(orderCode);
        if (orderToDelete == null || orderToDelete.getUserId() != userId) {
            logger.warn("Order {} not found or does not belong to user {}. Deletion aborted.", orderCode, userId);
            return false;
        }
        orderMapper.deleteCarItemByCodeAndUserId(orderCode, userId); // 假设这个方法会删除所有关联项，不一定返回删除的行数
        int orderDeletedCount = orderMapper.deleteOrderByCodeAndUserId(orderCode, userId);
        if (orderDeletedCount > 0) {
            logger.info("Order {} successfully deleted for userId: {}", orderCode, userId);
            return true;
        } else {
            logger.warn("Failed to delete order record for orderCode: {}. No rows affected.", orderCode);
            throw new RuntimeException("Failed to delete order record for " + orderCode + ". Deletion rolled back.");
        }
    }

    @Override
    @Transactional
    public void updateOrder(long orderCode, int userId, List<Integer> goodsIds, List<Integer> quantities) {
        logger.info("Attempting to update order {} for userId: {}", orderCode, userId);
        Order existingOrder = orderMapper.getOrderByOrderCode(orderCode);
        if (existingOrder == null || existingOrder.getUserId() != userId) {
            logger.warn("Order {} not found or does not belong to user {}. Update aborted.", orderCode, userId);
            throw new IllegalArgumentException("Order not found or permission denied for update.");
        }
        for (int i = 0; i < goodsIds.size(); i++) {
            int goodId = goodsIds.get(i);
            int quantity = quantities.get(i);
            if (quantity <= 0) {
                logger.warn("Invalid quantity {} for goodId {} in order {}. Skipping update.", quantity, goodId, orderCode);
                continue;
            }
            logger.debug("Updating quantity for goodId {} to {} in order {}", goodId, quantity, orderCode);
            orderMapper.updateCarItemQuantity(userId, goodId, orderCode, quantity);
        }
        List<Goods> goodsList = orderMapper.getGoodsByOrderCode(orderCode);
        double subtotal = 0;
        for (Goods g : goodsList) {
            subtotal += g.getSurprisePrice() * g.getNum();
        }
        double serviceFeePercentage = 0.02;
        double finalTotalPrice = subtotal * (1 + serviceFeePercentage);
        finalTotalPrice = Math.round(finalTotalPrice * 100.0) / 100.0;
        int updatedRows = orderMapper.updateOrderTotalPrice(orderCode, finalTotalPrice);
        if (updatedRows > 0) {
            logger.info("Order {} total price updated to: {}", orderCode, finalTotalPrice);
        } else {
            logger.warn("Failed to update total price for order {}. No rows affected.", orderCode);
        }
    }

    @Override
    public List<Integer> getGoodIdByCode(long orderCode) {
        return orderMapper.getGoodIdByCode(orderCode);
    }

    @Override
    public int getCodeNum(int userid, int goodid, long orderCode) {
        return orderMapper.getCodeNum(userid, goodid, orderCode);
    }

    @Override
    public List<Order> getAllOrdersForAdmin() { // 与接口一致
        logger.debug("Fetching all orders for admin.");
        return orderMapper.getAllOrdersForAdmin(); // 确保 OrderMapper.xml 有此ID的查询
    }

    @Override
    @Transactional
    public boolean markOrderAsShipped(long orderCode) { // 与接口一致


        logger.info("Attempting to mark order {} as SHIPPED.", orderCode);
        Order order = orderMapper.getOrderByOrderCode(orderCode);
        if (order == null) {
            logger.warn("Order {} not found. Cannot mark as shipped.", orderCode);
            return false;
        }
        if (STATUS_PENDING.equals(order.getStatus())) {
            int updatedRows = orderMapper.updateOrderStatus(orderCode, STATUS_SHIPPED);
            if (updatedRows > 0) {
                logger.info("Order {} successfully marked as SHIPPED.", orderCode);
                return true;
            } else {
                logger.error("Failed to update status to SHIPPED for order {}. No rows affected.", orderCode);
                throw new RuntimeException("Failed to update order status for " + orderCode + " to SHIPPED.");
            }
        } else {
            logger.warn("Order {} cannot be marked as shipped. Current status: {}. Expected: {}",
                    orderCode, order.getStatus(), STATUS_PENDING);
            return false;
        }
    }

    @Override
    public String payOrder(int userId, long orderCode, HttpSession session) {
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
    public void orderSuccess(int userId, long orderCode) {
        orderMapper.setPayed(orderCode);
    }

    @Override
    public void setPayed(long orderCode) {
        orderMapper.setPayed(orderCode);
    }
}
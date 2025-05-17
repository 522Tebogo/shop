package com.work.work.mapper;

import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderMapper {
    int insertOrder(Order order);
    int insertCode(long orderCode, int userId);// 建议为所有多参数方法添加 @Param

    List<Order> getOrderListByUserId(@Param("userId") int userId); // 建议为单参数也加上，保持一致性
    List<Goods> getGoodsByOrderCode(@Param("orderCode") long orderCode);
    Order getOrderByOrderCode(@Param("orderCode") long orderCode);
    int deleteCarItemByCodeAndUserId(@Param("orderCode") long orderCode, @Param("userId") int userId);
    int deleteOrderByCodeAndUserId(@Param("orderCode") long orderCode, @Param("userId") int userId);
    int updateCarItemQuantity(@Param("userId") int userId, @Param("goodId") int goodId, @Param("orderCode") long orderCode, @Param("quantity") int quantity);
    int updateOrderTotalPrice(@Param("orderCode") long orderCode, @Param("totalPrice") double totalPrice);
    List<Integer> getGoodIdByCode(long orderCode);
    int getCodeNum(int userid ,int goodid, long orderCode);

    // 保留一个获取所有订单给管理员的方法
    List<Order> getAllOrdersForAdmin(); // 与 Service 和 Controller 统一

    // 更新订单状态的方法
    int updateOrderStatus(@Param("orderCode") long orderCode, @Param("status") String status);
    int getPriceByCode(long orderCode);
    void setPayed(long orderCode);

}
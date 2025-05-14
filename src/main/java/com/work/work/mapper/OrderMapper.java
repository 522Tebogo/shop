package com.work.work.mapper;

import com.work.work.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {
    int insertOrder(Order order);
    int insertCode(long orderCode,int userId);
}

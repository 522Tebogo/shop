package com.work.work.service.ServiceImpl;

import com.alipay.api.AlipayClient;
import com.alipay.api.request.AlipayTradePagePayRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AlipayService {
    @Autowired
    private AlipayClient alipayClient;

    /**
       * 创建支付宝支付订单
       * 
       * @param orderNo 商户订单号，需要保证唯一性
       * @param totalAmount 订单金额，单位为元，精确到小数点后两位
       * @param subject 订单标题，会显示在支付宝收银台页面上
       * @return 返回支付宝收银台页面的HTML表单，可以直接输出到浏览器
       */
    public String createPayment(long orderNo, String totalAmount, String subject) {
  try {
    log.info("开始创建支付订单，订单号：{}，金额：{}，商品：{}", orderNo, totalAmount,
                    subject);
 
    // 创建支付请求
    AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
 
    // 设置异步通知地址
    request.setNotifyUrl("http://localhost:8080/alipay/notify");
    // 设置同步返回地址
    request.setReturnUrl("http://localhost:8080/order/alipay/return");
 
    // 构建请求参数
    // 注意：实际项目中应该使用对象来构建，这里为了简单使用字符串拼接
    String bizContent = "{" +
      "\"out_trade_no\":\"" + orderNo + "\"," +   // 商户订单号
      "\"total_amount\":\"" + totalAmount + "\"," + // 订单金额
      "\"subject\":\"" + subject + "\"," +      // 订单标题
      "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"" + // 固定值
      "}";
 
    log.info("支付请求参数：{}", bizContent);
 
    request.setBizContent(bizContent);

    // 使用GET方式获取支付表单
    String form = alipayClient.pageExecute(request, "GET").getBody();
    log.info("支付表单生成成功");
    return form;
   } catch (Exception e) {
    log.error("创建支付订单失败", e);
    throw new RuntimeException("创建支付订单失败：" + e.getMessage());
   }
    }
}

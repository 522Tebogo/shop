package com.work.work.config.interceptor;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AliPayconfig {
    private static final String URL = "https://openapi-sandbox.dl.alipaydev.com/gateway.do";
    private static final String APP_ID = "2021000148667210";
    private static final String PRIVATE_KEY = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCoW0fYOlq44om00/CTtQPKLATZB7pMRYEKRrO1Z9Qz0jG4v4BH8vaE7uD0vNts4Y6M/kZuFkMH7TLHRgb0P2MqRovBEOtmhyZ9Y4PXsOAZA2XdCpZaHuCbbMBq6ozLQngW2AyopepH7awmjkIhIHiCHrtoBJ2gGrfx9EfE6c48WOdzVlkaE/wu+ngK/U3wkdysEVZcrF+5mzcqbWSUHZTJ2/O9K2wP0d7osU68Zob3tMOLqcn8HeYcfrQs4nsMwBcn4/4FCh/Zeh8Yd2kzeDevTsaz3IaWDAFF2cz9PrPve8OOa3N+l6Th43gdMdeniY0OIsUnxzGxJ8392iFWfZiDAgMBAAECggEBAKQiyjqfOc/C3Oq1LnlzI0y5+cf15sVxhcsU/yO/JH2ZUeyCl3iOAZW8pwk0DuFqTmZbiSLPBW727GindyQtoGqY+Kuz6Sy+WuIoYWOqB/GbBHaqWcdnDye4sSgLoFSSay4qWL0bdPvHVe0JCKPvWk3R1Hgm994d7nQv6sCqCe1+T30Qyuhp/1dXWrK6Jji66fPtRrrYV7kXWr1wGTsOx++q2kxh3UiimeWPm9LgeugxsYashc5SI5YyMSb7MyDj5NLKT1yr3vypAqLDuyNWreIGlMwIfsg6P4VnqwHWMAjsQaeqVRpXDe/LoNpZfXYYBYYOypVg+e4w+kqwMwkg1XECgYEA7G+BB3pdG2X+KmK61ZuFq8YTeGFQGWPQjZK6OZ3BJAkqn3bUzHGuKq4V+G37S6Q+OLFdIY/PO+fYunDPtPe2tN/Q9ihka35PUlbp8KY2mGIXLv0Jg8mPHYkakmLzP9V10kjj15UWar81nnFPMqVn8CM5zmjmW46j7s0aHHhqtM0CgYEAtkmiwVUC0iGoWyziSG7xJLsbk+QDdA+lrIOltfrfXYTg41rT4VtLECYFzc5p5Pbb+bsckX5kucxTDopZfY2+ltRwM05RkQgPwgLb/D7hFum03F6RpLZJdiAI4JNZt7ig9PdN4NsKSwINAVpt1fqmI1LryC4IOXZxR3PTw8tdAo8CgYEAw4GwgC5+rxk3gnUBaYCgl9nCX9iYE2amHWsm8l2wR8wMoq/wZt3Z1xD8ueC322SEzvxatlXkVvTwEbsXBd2QByDL+cCMyRY5IS0dZREMNBVodkJmi8MvxIyKnGGWI0KvmqMLREjTsJFMFSg9BPQhbkCynCvB0BOzGtQes0wfcEECgYAJtFfe1QjGaRZObFBLrORXoUJxmCT6685VJdkPnCCCGQ3j7LT0/Wg8ntmWQFPw5ZeGbwixUjpIjfEqCAGFpqMr4nlqsdOz1esI2CAgCLTxBFYlmT9FtpKooEH4ur9/AWxIPlY+D0s3/Q72MHtCdgqcPNDioli7vmt/c1IlzVDRTwKBgFwS4+32Xu9K+MniaovhRfD33EBzsEql7BSQJihe60B7cSpcJ361w7gwASGxh0gC2DZ7voojawR+sqr/QixotE7au6wxe1wHfgL5HqwF61QuMfIRvGRO7MSXoSqRnPeQsaP0PfotLxaiKH0QKCKPu+GNHgpS9u2XX/4hlNOoyF4A";
    private static final String ALIPAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqFtH2DpauOKJtNPwk7UDyiwE2Qe6TEWBCkaztWfUM9IxuL+AR/L2hO7g9LzbbOGOjP5GbhZDB+0yx0YG9D9jKkaLwRDrZocmfWOD17DgGQNl3QqWWh7gm2zAauqMy0J4FtgMqKXqR+2sJo5CISB4gh67aASdoBq38fRHxOnOPFjnc1ZZGhP8Lvp4Cv1N8JHcrBFWXKxfuZs3Km1klB2UydvzvStsD9He6LFOvGaG97TDi6nJ/B3mHH60LOJ7DMAXJ+P+BQof2XofGHdpM3g3r07Gs9yGlgwBRdnM/T6z73vDjmtzfpek4eN4HTHXp4mNDiLFJ8cxsSfN/dohVn2YgwIDAQAB";
    private static final String NOTIFY_URL = "http://localhost:8080/alipay/notify";
    private static final String RETURN_URL = "http://localhost:8080/order/alipay/return";
    @Bean
 public AlipayClient alipayClient() {
   return new DefaultAlipayClient(
                     URL,        // 支付宝网关
                     APP_ID,      // 应用ID
                     PRIVATE_KEY,    // 商户私钥
                     "json",      // 请求格式
                     "UTF-8",     // 编码格式
                     ALIPAY_PUBLIC_KEY, // 支付宝公钥
                     "RSA2"      // 签名方式
                    );
   }
}


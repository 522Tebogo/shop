package com.work.work.config;

import com.work.work.config.interceptor.MyInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry){
        registry.addInterceptor(new MyInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/login/**",  // 排除所有登录相关子路径
                        "/user/register",
                        "/user/register/**", // 排除所有注册相关子路径
                        "/verification/**", // 排除验证码相关路径
                        "/css/**",
                        "/js/**",
                        "/static/**", // 排除所有静态资源
                        "/resources/**"
                );
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 注册静态资源访问路径
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/", "file:src/main/resources/static/", "file:src/main/webapp/static/");
    }
}

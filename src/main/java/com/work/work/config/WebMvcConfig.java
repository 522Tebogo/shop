package com.work.work.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Configure static resource access
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/", "file:src/main/webapp/static/");
                
        // 特别为头像添加映射
        registry.addResourceHandler("/static/images/avatars/**")
                .addResourceLocations("file:src/main/webapp/static/images/avatars/");
                
        // 添加默认头像映射
        registry.addResourceHandler("/static/images/default-avatar.png")
                .addResourceLocations("file:src/main/webapp/static/images/");
    }
} 
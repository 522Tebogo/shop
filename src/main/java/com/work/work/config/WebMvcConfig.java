package com.work.work.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${myapp.upload-dir.avatars}")
    private String avatarUploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置头像文件的访问路径
        registry.addResourceHandler("/static/images/avatars/**")
                .addResourceLocations("file:" + avatarUploadDir + "/");

        // 配置其他静态资源的访问路径
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/", "file:src/main/webapp/static/");
    }
}
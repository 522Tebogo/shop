package com.work.work.config.interceptor;

import com.work.work.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class MyInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,Object handler)throws Exception{
        if (request.getRequestURI().equals("/")){
            return true;
        }
        HttpSession session=request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null){
            return true;
        }else {
            session.setAttribute("msg","请先登录！");
            response.sendRedirect("/user/login");
            return false;
        }
    }
}

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            max-width: 450px;
            margin: 7% auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h2 {
            color: #5d6bdf;
            font-weight: 600;
        }
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: #5d6bdf;
            box-shadow: 0 0 0 0.2rem rgba(93, 107, 223, 0.25);
        }
        .btn-primary {
            background-color: #5d6bdf;
            border: none;
            padding: 12px;
            font-weight: 500;
            border-radius: 8px;
            width: 100%;
            margin-top: 10px;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
        }
        .login-footer {
            text-align: center;
            margin-top: 20px;
        }
        .login-footer a {
            color: #5d6bdf;
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo img {
            max-height: 60px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px;
            border-radius: 4px;
            display: inline-block;
            font-size: 20px;
        }
        .login-type-switcher {
            display: flex;
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }
        .login-type-switcher button {
            flex: 1;
            padding: 12px;
            border: none;
            background-color: #f8f9fa;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .login-type-switcher button.active {
            background-color: #5d6bdf;
            color: white;
        }
        .login-type-nav {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .login-type-nav a {
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 20px;
            color: #5d6bdf;
            text-decoration: none;
            font-weight: 500;
        }
        .login-type-nav a.active {
            background-color: #5d6bdf;
            color: white;
        }
    </style>
</head>

<body>
    <!-- 调试信息 -->
    <% System.out.println("Login JSP - 成功消息: " + request.getAttribute("successMessage")); %>
    <% System.out.println("Login JSP - 错误消息: " + request.getAttribute("loginError")); %>
    
    <div class="container">
        <div class="login-container">
            <div class="logo">
                <div class="default-logo">嗨购商城</div>
            </div>
            
            <div class="login-header">
                <h2>用户登录</h2>
                <p class="text-muted">欢迎回来！请输入您的账号信息</p>
            </div>
            
            <div class="login-type-nav">
                <a href="/user/login" class="active">账号密码登录</a>
                <a href="/user/login/phone">手机验证码登录</a>
                <a href="/user/login/email">邮箱验证码登录</a>
            </div>
            
            <!-- 显示成功消息 -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
                </div>
            </c:if>
            
            <!-- 显示错误消息 -->
            <c:if test="${not empty loginError}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${loginError}
                </div>
            </c:if>
            
            <!-- 用户登录表单 -->
            <form action="/user/login" method="post" id="userLoginForm">
                <div class="mb-3">
                    <label for="account" class="form-label">用户名</label>
                    <input type="text" class="form-control" id="account" name="account" placeholder="请输入您的用户名" required>
                    <div class="form-text">用户名只能包含字母和数字，且不能以数字开头，6~10位</div>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">密码</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="请输入您的密码" required>
                    <div class="form-text">密码只能包含字母和数字，且必须以大写字母开头，6~10位</div>
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="remember">
                    <label class="form-check-label" for="remember">记住我</label>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-box-arrow-in-right me-2"></i> 登录
                </button>
            </form>
            
            <div class="login-footer">
                <p>还没有账号？<a href="/user/register">立即注册</a></p>
                <p class="mt-3"><small class="text-muted">登录即表示您同意我们的服务条款和隐私政策</small></p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // 修复登录切换方式
            $('.login-type-nav a').click(function(e) {
                const href = $(this).attr('href');
                window.location.href = href;
            });
        });
    </script>
</body>
</html>

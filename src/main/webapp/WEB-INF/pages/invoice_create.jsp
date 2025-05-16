<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <title>申请发票 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 70px;
        }
        .navbar-brand img {
            height: 40px;
        }
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        /* 页脚样式 */
        footer.footer {
            padding: 20px 0;
            background-color: #fff;
            border-top: 1px solid #dee2e6;
            margin-top: 50px;
            color: #6c757d;
            text-align: center;
            font-size: 0.9rem;
        }
        /* 顶部欢迎和账户菜单 */
        .welcome-message {
            margin-bottom: 0;
            margin-right: 20px;
        }
        /* 表单样式 */
        .invoice-form {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            padding: 30px;
            max-width: 600px;
            margin: 30px auto;
        }
        .invoice-form h1 {
            color: #5d6bdf;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
        }
        .invoice-form label {
            font-weight: 600;
            margin-top: 10px;
        }
        .invoice-form input[type="text"] {
            width: 100%;
            padding: 8px 10px;
            margin-top: 5px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .invoice-form button {
            margin-top: 20px;
            width: 100%;
        }
        .error-msg {
            color: red;
            margin-top: 15px;
            text-align: center;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="default-logo" style="background-color:#5d6bdf; color:#fff; font-weight:bold; padding:10px 15px; border-radius:4px; display:inline-block;">
                嗨购商城
            </div>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="/"><i class="bi bi-house-door"></i> 首页</a></li>
                <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-grid"></i> 商品分类</a></li>
                <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-star"></i> 热卖商品</a></li>
                <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-gift"></i> 限时特惠</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (session.getAttribute("user") != null) { %>
                <p class="welcome-message"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" width="50px" height="50px" alt="用户头像" class="user-avatar me-2" />
                    </c:when>
                    <c:otherwise>
                        <div style="width: 35px; height: 35px; background-color: #e9ecef; border-radius: 50%;
                                    display: flex; align-items: center; justify-content: center; margin-right: 10px;">
                            <i class="bi bi-person"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="userDropdown"
                            data-bs-toggle="dropdown" aria-expanded="false">我的账户</button>
                    <ul class="dropdown-menu" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item active" href="#"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-gear"></i> 账户设置</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="/user/login" class="btn btn-outline-primary me-2"><i class="bi bi-box-arrow-in-right"></i> 登录</a>
                <a href="/user/register" class="btn btn-primary"><i class="bi bi-person-plus"></i> 注册</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- 内容区 -->
<div class="container">
    <form class="invoice-form" action="${pageContext.request.contextPath}/invoice/create" method="post">
        <h1>申请发票</h1>

        <input type="hidden" name="orderCode" value="${order.orderCode}">
        <input type="hidden" name="amount" value="${order.totalPrice}">

        <div>
            <label>订单号:</label>
            <span>${order.orderCode}</span>
        </div>

        <div>
            <label>金额:</label>
            <span>¥${order.totalPrice}</span>
        </div>

        <div>
            <label for="title">发票抬头:</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div>
            <label for="taxNumber">税号:</label>
            <input type="text" id="taxNumber" name="taxNumber" required>
        </div>

        <button type="submit" class="btn btn-primary">提交申请</button>

        <c:if test="${not empty error}">
            <div class="error-msg">${error}</div>
        </c:if>
    </form>
</div>

<!-- 底部栏 -->
<footer class="footer">
    <div class="container">
        &copy; 2025 嗨购商城 版权所有
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

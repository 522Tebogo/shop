<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单确认 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
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
        .section-title {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .section-title:after {
            content: '';
            width: 70px;
            height: 3px;
            background: #6e8efb;
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        .order-item {
            background: white;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }
        .order-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 4px;
        }
        .welcome-message {

            margin-bottom: 0;
            margin-right: 20px;

        }
        .order-item-details {
            flex-grow: 1;
        }
        .order-total {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/"><div class="default-logo">嗨购商城</div></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-grid"></i> 商品分类</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-star"></i> 热卖商品</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-gift"></i> 限时特惠</a>
                </li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (session.getAttribute("user") != null) { %>
                <p class="welcome-message"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}"width="50px" height="50px" alt="用户头像" class="user-avatar me-2">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 35px; height: 35px; background-color: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 10px;">
                            <i class="bi bi-person"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        我的账户
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item active" href=""><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-basket"></i> 我的订单</a></li>
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

<div class="container mt-5">
    <h2 class="section-title">订单确认</h2>
    <div class="order-total">
        <h4>订单信息</h4>
        <hr>
        <div class="d-flex justify-content-between">
            <p>订单编号:</p>
            <p class="fw-bold" id="order-id">${orderId}</p>
        </div>
        <div class="d-flex justify-content-between">
            <p>下单时间:</p>
            <p class="fw-bold" id="current-time">${currentTime}</p>
        </div>
        <hr>
        <h5>订单详情</h5>
        <c:set var="totalPrice" value="0" />
        <c:forEach var="item" items="${goods}">
            <c:set var="itemTotal" value="${item.normalPrice * item.num}" />
            <c:set var="totalPrice" value="${totalPrice + itemTotal}" />
        </c:forEach>

        <c:set var="shippingFee" value="${totalPrice * 0.05}" />
        <c:set var="finalTotal" value="${totalPrice + shippingFee}" />
        <c:forEach var="item" items="${goods}">


            <div class="order-item">
                <img src="${item.imageUrl}" alt="${item.name}">
                <div class="order-item-details">
                    <h5>${item.name}</h5>
                    <p class="text-muted">规格: ${item.description}</p>
                    <p class="text-danger fw-bold">¥<fmt:formatNumber value="${item.normalPrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
                    <p class="text-muted">数量: ${item.num}</p>
                    <p class="text-muted">小计: ¥<fmt:formatNumber value="${item.normalPrice * item.num}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
                </div>
            </div>
        </c:forEach>
        <hr>
        <div class="d-flex justify-content-between">
            <p>购物车商品价格总和:</p>
            <p class="fw-bold" id="total-price">¥<fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
        </div>
        <div class="d-flex justify-content-between">
            <p>运费 (5%):</p>
            <p class="fw-bold" id="shipping-fee">¥<fmt:formatNumber value="${shippingFee}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
        </div>
        <hr>
        <div class="d-flex justify-content-between">
            <h5>应付总额:</h5>
            <h5 class="text-danger fw-bold">¥<span id="final-total"><fmt:formatNumber value="${finalTotal}" type="number" maxFractionDigits="2" minFractionDigits="2"/></span></h5>
        </div>
        <div class="text-end mt-3">
            <form action="/order/submit" method="POST">
                <input type="hidden" name="userId" value="${user.id}"/>
                <input type="hidden" name="totalPrice" value="${finalTotal}"/>
                <input type="hidden" name="orderCode" value="${orderId}"/>
                <button type="submit" class="btn btn-primary"><i class="bi bi-credit-card"></i> 确认订单</button>
            </form>
        </div>
    </div>
</div>

<footer class="footer mt-5">
    <div class="container">
        <!-- Footer content here -->
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 模拟生成订单编号（格式：YYYYMMDDHHMMSS）
    const currentDate = new Date();
    const orderId = currentDate.getFullYear() + ('0' + (currentDate.getMonth() + 1)).slice(-2) + ('0' + currentDate.getDate()).slice(-2) +
        ('0' + currentDate.getHours()).slice(-2) + ('0' + currentDate.getMinutes()).slice(-2) +
        ('0' + currentDate.getSeconds()).slice(-2);
    document.getElementById('order-id').textContent = orderId;

    // 在隐藏的表单字段中设置订单号
    document.getElementsByName('orderCode')[0].value = orderId;

    // 显示当前时间
    const currentTime = currentDate.toLocaleString();
    document.getElementById('current-time').textContent = currentTime;
</script>


</body>
</html>

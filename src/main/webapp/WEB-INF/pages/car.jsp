<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的购物车 - 嗨购商城</title>
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
        .welcome-message {

            margin-bottom: 0;
            margin-right: 20px;

        }
        .cart-item {
            background: white;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 4px;
        }
        .cart-item-details {
            flex-grow: 1;
        }
        .cart-item-actions {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .cart-item-actions button {
            margin-top: 5px;
        }
        .cart-total {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
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
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="default-logo">嗨购商城</div>
        </a>
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
                        <li><a class="dropdown-item" href="/user/profile"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item active" href="/car/toCar"><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item" href="/address/list"><i class="bi bi-geo-alt"></i> 收货地址</a></li>
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
    <h2 class="section-title">我的购物车</h2>

    <!-- 添加返回按钮 -->
    <div class="d-flex justify-content-end mb-4">
        <a href="/" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> 返回首页
        </a>
    </div>


    <c:if test="${empty goods}">
        <div class="alert alert-info" role="alert">
            您的购物车空空如也，快去<a href="/" class="alert-link">首页</a>看看吧！
        </div>
    </c:if>

    <c:if test="${not empty goods}">

        <%-- 计算总价、运费、应付总额 --%>
        <c:set var="totalPrice" value="0" />
        <c:forEach var="item" items="${goods}">
            <c:set var="itemTotal" value="${item.surprisePrice * item.num}" />
            <c:set var="totalPrice" value="${totalPrice + itemTotal}" />
        </c:forEach>
        <c:set var="shippingFee" value="${totalPrice * 0.02}" />
        <c:set var="finalTotal" value="${totalPrice + shippingFee}" />

        <%-- 商品列表显示 --%>
        <c:forEach var="item" items="${goods}">
            <div class="cart-item">
                <img src="${item.imageUrl}" alt="${item.name}">
                <div class="cart-item-details">
                    <h5>${item.name}</h5>
                    <p class="text-muted">规格: ${item.description}</p>
                    <p class="text-danger fw-bold">¥<fmt:formatNumber value="${item.surprisePrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>

                    <div class="d-flex align-items-center">
                        <label for="quantity-${item.id}" class="me-2">数量:</label>
                        <input type="number" class="form-control form-control-sm quantity-input" id="quantity-${item.id}" value="${item.num}" min="1" style="width: 70px;" data-good-id="${item.id}">
                    </div>
                </div>
                <div class="cart-item-actions">
                    <a href="/car/remove/${item.id}"> <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i> 移除</button> </a>
                </div>
            </div>
        </c:forEach>

        <%-- 总价区块 --%>
        <div class="cart-total">
            <h4>订单总计</h4>
            <hr>
            <div class="d-flex justify-content-between">
                <p>购物车商品价格总和:</p>
                <p class="fw-bold" id="total-price">¥<fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
            </div>
            <div class="d-flex justify-content-between">
                <p>运费 (2%):</p>
                <p class="fw-bold" id="shipping-fee">¥<fmt:formatNumber value="${shippingFee}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
            </div>
            <hr>
            <div class="d-flex justify-content-between">
                <h5>应付总额:</h5>
                <h5 class="text-danger fw-bold">¥<span id="final-total"><fmt:formatNumber value="${finalTotal}" type="number" maxFractionDigits="2" minFractionDigits="2"/></span></h5>
            </div>
            <div class="text-end mt-3">
                <form id="checkoutForm" method="GET" action="/order/toOrder">
                    <div id="goodIdInputs"></div>
                    <button type="submit" class="btn btn-primary"><i class="bi bi-credit-card"></i> 去结算</button>
                </form>
            </div>
        </div>
    </c:if>


</div>

<footer class="footer mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <h5>关于我们</h5>
                <ul class="list-unstyled">
                    <li><a href="#">公司简介</a></li>
                    <li><a href="#">企业文化</a></li>
                    <li><a href="#">发展历程</a></li>
                    <li><a href="#">联系我们</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>帮助中心</h5>
                <ul class="list-unstyled">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">支付方式</a></li>
                    <li><a href="#">配送方式</a></li>
                    <li><a href="#">售后服务</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>商家服务</h5>
                <ul class="list-unstyled">
                    <li><a href="#">商家入驻</a></li>
                    <li><a href="#">商家中心</a></li>
                    <li><a href="#">营销服务</a></li>
                    <li><a href="#">物流服务</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>关注我们</h5>
                <p>
                    <i class="bi bi-wechat me-2"></i> 官方微信<br>
                    <i class="bi bi-phone me-2"></i> 客服热线: 400-123-4567<br>
                    <i class="bi bi-envelope me-2"></i> 客服邮箱: service@example.com
                </p>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="text-center">
            <p>© 2024 嗨购商城. 保留所有权利.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 监听商品数量的变化
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', function() {
            const goodId = this.getAttribute('data-good-id');
            const quantity = this.value;

            // 发送 AJAX 请求更新数据库中的商品数量
            fetch('/car/updateQuantity', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ goodId: goodId, quantity: quantity })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 更新页面上的总价等信息
                        updateCartData(data.updatedGoods);
                    } else {
                        alert('库存不足！');
                    }
                })
                .catch(error => {
                    console.error('请求失败:', error);
                });
        });
    });


    // 更新购物车总价等数据
    function updateCartData(goods) {
        // 重新计算总价、运费和应付总额等
        let totalPrice = 0;
        let shippingFee = 0;
        goods.forEach(item => {
            totalPrice += item.surprisePrice * item.num;
        });
        shippingFee = totalPrice * 0.02;
        let finalTotal = totalPrice + shippingFee;

        // 更新页面上的显示
        document.querySelector('#total-price').textContent = '¥' + totalPrice.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        document.querySelector('#shipping-fee').textContent = '¥' + shippingFee.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        document.querySelector('#final-total').textContent = finalTotal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
</script>

</body>
</html>
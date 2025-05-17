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
        .address-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .address-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .address-card:hover {
            border-color: #5d6bdf;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .address-card.selected {
            border: 2px solid #5d6bdf;
            background-color: #f9f9ff;
        }
        .default-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #5d6bdf;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .no-address-alert {
            padding: 15px;
            border-radius: 8px;
            background-color: #f8d7da;
            color: #721c24;
            margin-bottom: 15px;
        }
        .add-address-card {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .add-address-card:hover {
            border-color: #5d6bdf;
            background-color: #f8f9ff;
        }
        .add-address-icon {
            font-size: 2rem;
            color: #5d6bdf;
            margin-bottom: 10px;
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
                        <li><a class="dropdown-item" href="/user/profile"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-cart"></i> 购物车</a></li>
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
    <h2 class="section-title">订单确认</h2>

    <!-- 显示错误消息 -->
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- 收货地址 -->
    <div class="address-section">
        <h4><i class="bi bi-geo-alt-fill"></i> 收货地址</h4>
        <hr>

        <c:choose>
            <c:when test="${empty addresses}">
                <div class="no-address-alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> 您还没有添加收货地址，请点击下方按钮添加
                </div>
                <a href="/address/add" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> 添加收货地址
                </a>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="address" items="${addresses}">
                        <div class="col-md-6">
                            <div class="address-card ${address.isDefault ? 'selected' : ''}" data-address-id="${address.id}">
                                <c:if test="${address.isDefault}">
                                    <span class="default-badge">默认地址</span>
                                </c:if>

                                <h5><i class="bi bi-person-fill"></i> ${address.receiver}</h5>
                                <p class="mb-1"><i class="bi bi-telephone-fill"></i> ${address.phone}</p>
                                <p><i class="bi bi-geo-alt-fill"></i> ${address.province} ${address.city} ${address.district} ${address.detailAddress}</p>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="col-md-6">
                        <a href="/address/add" class="text-decoration-none">
                            <div class="add-address-card">
                                <div class="add-address-icon">
                                    <i class="bi bi-plus-circle"></i>
                                </div>
                                <h5>添加新地址</h5>
                                <p class="text-muted">添加一个新的收货地址</p>
                            </div>
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 订单商品列表 -->
    <div class="order-items">
        <h4><i class="bi bi-basket-fill"></i> 商品清单</h4>
        <hr>

        <c:forEach var="item" items="${goods}">
            <div class="order-item">
                <img src="${item.imageUrl}" alt="${item.name}">
                <div class="order-item-details">
                    <h5>${item.name}</h5>
                    <p class="text-muted">规格: ${item.description}</p>
                    <p class="text-danger fw-bold">¥<fmt:formatNumber value="${item.surprisePrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/> x ${item.num}</p>
                </div>
                <div class="order-item-subtotal">
                    <p class="fw-bold">小计: ¥<fmt:formatNumber value="${item.surprisePrice * item.num}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 订单总计 -->
    <c:set var="totalPrice" value="0" />
    <c:forEach var="item" items="${goods}">
        <c:set var="itemTotal" value="${item.surprisePrice * item.num}" />
        <c:set var="totalPrice" value="${totalPrice + itemTotal}" />
    </c:forEach>
    <c:set var="shippingFee" value="${totalPrice * 0.02}" />
    <c:set var="finalTotal" value="${totalPrice + shippingFee}" />

    <div class="order-total">
        <h4>订单总计</h4>
        <hr>
        <div class="d-flex justify-content-between">
            <p>商品金额:</p>
            <p>¥<fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
        </div>
        <div class="d-flex justify-content-between">
            <p>运费 (2%):</p>
            <p>¥<fmt:formatNumber value="${shippingFee}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
        </div>
        <hr>
        <div class="d-flex justify-content-between">
            <h5>应付总额:</h5>
            <h5 class="text-danger fw-bold">¥<fmt:formatNumber value="${finalTotal}" type="number" maxFractionDigits="2" minFractionDigits="2"/></h5>
        </div>

        <form action="/order/submit" method="post" id="orderForm">
            <input type="hidden" name="userId" value="${user.id}">
            <input type="hidden" name="totalPrice" value="${finalTotal}">
            <input type="hidden" name="orderCode" value="${System.currentTimeMillis()}">
            <input type="hidden" name="addressId" id="selectedAddressId" value="${defaultAddress.id}">

            <div class="text-end mt-3">
                <a href="/car/toCar" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> 返回购物车
                </a>
                <button type="submit" class="btn btn-primary" id="submitOrderBtn" ${empty addresses ? 'disabled' : ''}>
                    <i class="bi bi-credit-card"></i> 提交订单
                </button>
            </div>
        </form>
    </div>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 点击地址卡片选择地址
        $('.address-card').click(function() {
            $('.address-card').removeClass('selected');
            $(this).addClass('selected');
            const addressId = $(this).data('address-id');
            $('#selectedAddressId').val(addressId);
        });

        // 提交订单前验证是否选择了地址
        $('#orderForm').submit(function(e) {
            const addressId = $('#selectedAddressId').val();
            if (!addressId) {
                e.preventDefault();
                alert('请选择收货地址');
                return false;
            }
            return true;
        });
    });
</script>
</body>
</html>

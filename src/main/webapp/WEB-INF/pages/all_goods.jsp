<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品展示 - 嗨购商城</title>
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
        .hero-section {
            background: linear-gradient(135deg, #6e8efb, #a777e3);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        .feature-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 20px;
            color: #6e8efb;
        }
        .footer {
            background: #343a40;
            color: white;
            padding: 40px 0;
            margin-top: 50px;
        }
        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }
        .footer a:hover {
            color: white;
            text-decoration: underline;
        }
        .section-title {
            text-align: center;
            margin-bottom: 50px;
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
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }

        .welcome-message {
            margin-bottom: 0;
            margin-right: 20px;
        }

        .toast-container {
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 1050;
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

        .product-image {
            height: 220px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
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
                    <a class="nav-link active" href="/"><i class="bi bi-house-door"></i> 首页</a>
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
                        <img src="${user.avatar}" alt="用户头像" class="user-avatar me-2">
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
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-person"></i>购物车</a></li>
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

<!-- 分类导航区域 -->
<div class="container mt-4">
    <div class="d-flex justify-content-center flex-wrap gap-2">
        <a href="/good/all" class="btn btn-outline-primary ${param.category == '全部' || param.category == null ? 'active' : ''}">全部</a>
        <a href="/good/all?category=数码" class="btn btn-outline-primary ${param.category == '数码' ? 'active' : ''}">数码</a>
        <a href="/good/all?category=电器" class="btn btn-outline-primary ${param.category == '电器' ? 'active' : ''}">电器</a>
        <a href="/good/all?category=服饰" class="btn btn-outline-primary ${param.category == '服饰' ? 'active' : ''}">服饰</a>
        <a href="/good/all?category=食品" class="btn btn-outline-primary ${param.category == '食品' ? 'active' : ''}">食品</a>
    </div>
</div>

<!-- 商品展示区域 -->
<div class="container py-5">
    <h2 class="section-title">
        <c:choose>
            <c:when test="${not empty param.category && param.category != '全部'}">${param.category}</c:when>
            <c:otherwise>全部商品</c:otherwise>
        </c:choose>
    </h2>

    <div class="row">
        <c:forEach var="item" items="${goods}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100">
                        <div class="product-image">
                            <img src="${item.imageUrl}" alt="${item.name}" class="img-fluid">
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${item.name}</h5>
                            <p class="text-danger fw-bold">惊喜价 ¥${item.surprisePrice}</p>
                            <p class="text-muted text-decoration-line-through">原价 ¥${item.normalPrice}</p>
                            <p class="text-muted small">${item.description}</p>
                            <p class="text-secondary small">分类：${item.category}</p>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <a href="/good/single/${item.id}" class="btn btn-outline-primary w-100">
                                <i class="bi bi-basket"></i> 查看详情
                            </a>
                        </div>
                    </div>
                </div>
        </c:forEach>
    </div>
</div>

<!-- 页脚 -->
<footer class="footer">
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
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

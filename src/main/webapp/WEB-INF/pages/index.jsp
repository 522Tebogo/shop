<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>首页 - 嗨购商城</title>
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
        .hero-section h1 {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 20px;
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
            overflow: hidden;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;  /* 保持图片比例并且填充容器 */
        }

    </style>
</head>
<body>
<!-- 导航条 -->
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
                    <a class="nav-link" href="/good/all"><i class="bi bi-grid"></i> 商品分类</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/good/hot"><i class="bi bi-star"></i> 热卖商品</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/good/discount"><i class="bi bi-gift"></i> 限时特惠</a>
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
                        <li><a class="dropdown-item" href="/user/profile"><i class="bi bi-person"></i> 个人资料</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-person"></i>购物车</a></li>
                        <li><a class="dropdown-item" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item" href="/invoice/list"><i class="bi bi-basket"></i> 我的发票</a></li>

                        <li><a class="dropdown-item" href="/user/password"><i class="bi bi-key"></i> 修改密码</a></li>
                        <li><a class="dropdown-item" href="/user/phone"><i class="bi bi-phone"></i> 绑定手机</a></li>
                        <li><a class="dropdown-item" href="/user/email"><i class="bi bi-envelope"></i> 绑定邮箱</a></li>

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


<% System.out.println("JSP中的成功消息: " + request.getAttribute("successMessage")); %>


<c:if test="${not empty successMessage}">
    <div class="toast-container">
        <div class="toast show align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="bi bi-check-circle me-2"></i> ${successMessage}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>
</c:if>


<section class="hero-section">
    <div class="container">
        <h1>欢迎来到嗨购商城</h1>
        <p class="lead mb-4">精选全球好物，为您提供优质的购物体验</p>
        <div class="d-flex justify-content-center">
            <form class="d-flex" style="max-width: 500px; width: 100%;">
                <input class="form-control me-2 py-2" type="search" placeholder="搜索商品..." aria-label="Search">
                <button class="btn btn-light px-2" type="submit" style="width: 100px"><i class="bi bi-search"></i> 搜索</button>
            </form>
        </div>
    </div>
</section>


<section class="py-5">
    <div class="container">
        <h2 class="section-title">我们的特色服务</h2>
        <div class="row">
            <div class="col-md-3">
                <div class="feature-card text-center">
                    <i class="bi bi-truck feature-icon"></i>
                    <h5>快速配送</h5>
                    <p>全国大部分地区支持次日达，特定地区支持当日达。</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card text-center">
                    <i class="bi bi-shield-check feature-icon"></i>
                    <h5>品质保障</h5>
                    <p>所有商品均经过严格质检，支持7天无理由退换。</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card text-center">
                    <i class="bi bi-credit-card feature-icon"></i>
                    <h5>安全支付</h5>
                    <p>支持多种支付方式，交易全程安全加密。</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-card text-center">
                    <i class="bi bi-headset feature-icon"></i>
                    <h5>贴心服务</h5>
                    <p>7×24小时客服支持，解决您的任何问题。</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 热门商品 -->
<section class="py-5 bg-light">
    <div class="container">
        <h2 class="section-title">热门商品推荐</h2>
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
    <div class="text-center mt-4">
        <a href="/good/all" class="btn btn-primary">查看更多商品 <i class="bi bi-arrow-right"></i></a>
    </div>
    </div>
</section>

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
        <hr class="my-4 bg-secondary">
        <div class="text-center">
            <p>© 2024 嗨购商城. 保留所有权利.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 自动隐藏提示消息
    $(document).ready(function() {
        setTimeout(function() {
            $('.toast').toast('hide');
        }, 5000);
    });
</script>


</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <title>我的订单列表 - 嗨购商城</title>
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
        .order-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            padding: 20px;
        }
        .order-header {
            border-bottom: 2px solid #6e8efb;
            margin-bottom: 15px;
            padding-bottom: 10px;
            font-weight: 600;
            font-size: 1.2rem;
            color: #3a3f51;
        }
        .order-info {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .goods-table thead th {
            background-color: #e9ecef;
            font-weight: 600;
            vertical-align: middle;
            text-align: center;
        }
        .goods-table tbody td {
            vertical-align: middle;
            text-align: center;
        }
        .goods-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        .no-orders {
            text-align: center;
            font-size: 1.2rem;
            color: #999;
            margin-top: 50px;
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
    <h2 class="mb-4 text-center" style="color:#5d6bdf; font-weight:bold; position: relative; padding-bottom: 10px;margin-top: 10px">
        我的订单列表
        <span style="display:block; width: 70px; height: 3px; background:#6e8efb; margin: 6px auto 0;"></span>
    </h2>

    <c:choose>
        <c:when test="${empty orderList}">
            <p class="no-orders">暂无订单，赶快去购物吧！</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orderList}">
                <div class="order-card">
                    <div class="order-header">
                        订单号：${order.orderCode}
                        <span class="order-info float-end">
                            下单时间：<fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
总金额：<span class="text-danger fw-bold">¥<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                            <a href="/order/edit/${order.orderCode}" class="btn btn-sm btn-outline-primary me-2">
            <i class="bi bi-pencil"></i> 编辑
        </a>
        <a href="/order/delete/${order.orderCode}" class="btn btn-sm btn-outline-danger" onclick="return confirm('确定要删除该订单吗？');">
            <i class="bi bi-trash"></i> 删除
        </a>
                        </span>
                    </div>

                    <table class="table goods-table mb-0">
                        <thead>
                        <tr>
                            <th>商品图片</th>
                            <th>商品名称</th>
                            <th>普通价格</th>
                            <th>惊喜价格</th>
                            <th>商品描述</th>
                            <th>分类</th>
                            <th>购买数量</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="goods" items="${orderGoodsMap[order.orderCode]}">
                            <tr>
                                <td>
                                    <img src="${goods.imageUrl}" alt="${goods.name}" class="goods-img" />
                                </td>
                                <td>${goods.name}</td>
                                <td>¥${goods.normalPrice}</td>
                                <td>¥${goods.surprisePrice}</td>
                                <td>${goods.description}</td>
                                <td>${goods.category}</td>
                                <td>${goods.num}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
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

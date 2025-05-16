<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <title>发票详情 - 嗨购商城</title>
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
        .detail-label {
            font-weight: 600;
            width: 100px;
            display: inline-block;
        }
        .detail-row {
            margin-bottom: 12px;
        }
        .detail-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            padding: 20px;
            max-width: 600px;
            margin: 20px auto;
        }
        a.btn-back {
            margin-top: 20px;
            display: inline-block;
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
        发票详情
        <span style="display:block; width: 70px; height: 3px; background:#6e8efb; margin: 6px auto 0;"></span>
    </h2>

    <div class="detail-container">
        <div class="detail-row">
            <span class="detail-label">发票号码:</span>
            <span>${invoice.invoiceNumber}</span>
        </div>

        <div class="detail-row">
            <span class="detail-label">订单号:</span>
            <span>${invoice.orderCode}</span>
        </div>

        <div class="detail-row">
            <span class="detail-label">发票抬头:</span>
            <span>${invoice.title}</span>
        </div>

        <div class="detail-row">
            <span class="detail-label">税号:</span>
            <span>${invoice.taxNumber}</span>
        </div>

        <div class="detail-row">
            <span class="detail-label">金额:</span>
            <span>¥${invoice.amount}</span>
        </div>

        <div class="detail-row">
            <span class="detail-label">状态:</span>
            <span>
                <c:choose>
                    <c:when test="${invoice.status == 0}">未开具</c:when>
                    <c:when test="${invoice.status == 1}">已开具</c:when>
                    <c:when test="${invoice.status == 2}">已删除</c:when>
                </c:choose>
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">创建时间:</span>
            <span><fmt:formatDate value="${invoice.createTime}" pattern="yyyy-MM-dd HH:mm" /></span>
        </div>

        <c:if test="${invoice.status == 1}">
            <div class="detail-row">
                <span class="detail-label">开具时间:</span>
                <span><fmt:formatDate value="${invoice.updateTime}" pattern="yyyy-MM-dd HH:mm" /></span>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/invoice/list" class="btn btn-secondary btn-back">
            <i class="bi bi-arrow-left"></i> 返回列表
        </a>
    </div>
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

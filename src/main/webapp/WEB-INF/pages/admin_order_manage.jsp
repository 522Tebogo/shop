<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>后台管理 - 订单发货管理</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            min-height: 100vh;
            flex-direction: column;
        }
        .admin-navbar {
            background-color: #343a40;
            color: #f8f9fa;
            padding: 0.75rem 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }
        .admin-navbar .navbar-brand {
            color: #fff;
            font-weight: bold;
            font-size: 1.5rem;
        }
        .admin-navbar .nav-link,
        .admin-navbar .user-info span,
        .admin-navbar .user-info a {
            color: #adb5bd;
            margin-left: 15px;
        }
        .admin-navbar .nav-link:hover,
        .admin-navbar .user-info a:hover {
            color: #fff;
        }
        .admin-navbar .user-info .bold {
            color: #fff;
        }

        .admin-main-wrapper {
            display: flex;
            flex-grow: 1;
        }
        #admin_left {
            width: 250px;
            background-color: #495057;
            padding: 20px 0;
            color: #f8f9fa;
            min-height: calc(100vh - 56px); /* Navbar 高度 Bootstrap 默认56px */
            position: relative;
        }
        #admin_left .menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        #admin_left .menu li a {
            display: block;
            padding: 12px 20px;
            color: #e9ecef;
            text-decoration: none;
            transition: background-color 0.2s ease, color 0.2s ease;
            border-left: 3px solid transparent;
        }
        #admin_left .menu li a:hover,
        #admin_left .menu li a.active {
            background-color: #5a6268;
            color: #fff;
            border-left-color: #6e8efb;
        }
        #admin_left .menu li a i {
            margin-right: 10px;
        }
        #copyright {
            text-align: center;
            padding: 20px 0;
            font-size: 0.85em;
            color: #adb5bd;
            position: absolute;
            bottom: 10px;
            width: 100%;
        }

        #admin_right {
            flex-grow: 1;
            padding: 30px;
            background-color: #fff;
        }
        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .table th {
            white-space: nowrap;
        }
        .table td {
            vertical-align: middle;
        }
        .action-buttons .btn {
            margin: 2px;
            min-width: 120px;
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }
        .status-shipped {
            color: #198754;
            font-weight: bold;
        }
        .status-delivered {
            color: #0d6efd;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="admin-navbar navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/admin'/>">
            <span class="default-admin-logo">嗨购后台</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbarContent" aria-controls="adminNavbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="background-image: url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e\");"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbarContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center user-info">
                <li class="nav-item">
                    <span>您好, <label class='bold'>${sessionScope.user.account != null ? sessionScope.user.account : (sessionScope.loginUser.account != null ? sessionScope.loginUser.account : '管理员')}</label></span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/'/>" target='_blank'><i class="bi bi-shop"></i> 商城首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin'/>"><i class="bi bi-speedometer2"></i> 后台首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/logout'/>"><i class="bi bi-box-arrow-right"></i> 退出管理</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- 主体内容 -->
<div class="admin-main-wrapper">
    <div id="admin_left">
        <ul class="menu">
            <li><a href="<c:url value='/admin'/>" class="${pageContext.request.requestURI.endsWith('/admin') && !pageContext.request.requestURI.contains('/admin/') ? 'active' : ''}"><i class="bi bi-house-door-fill"></i> 管理首页</a></li>
            <li><a href="<c:url value='/admin/goods/add'/>" class="${pageContext.request.requestURI.contains('/admin/goods/add') ? 'active' : ''}"><i class="bi bi-plus-square-fill"></i> 商品管理</a></li>
            <li><a href="<c:url value='/admin/user/list'/>" class="${pageContext.request.requestURI.contains('/admin/user/list') ? 'active' : ''}"><i class="bi bi-people-fill"></i> 用户列表</a></li>
            <li><a href="<c:url value='/admin/orders/manage'/>" class="${pageContext.request.requestURI.contains('/admin/orders/manage') ? 'active' : ''}"><i class="bi bi-truck"></i> 订单发货管理</a></li>
        </ul>
        <div id="copyright">© 2024 嗨购后台</div>
    </div>

    <div id="admin_right">
        <h2 class="page-title"><i class="bi bi-truck"></i> 订单发货管理</h2>

        <!-- 成功/失败提示 -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 订单表格 -->
        <div class="table-responsive">
            <table class="table table-striped table-hover table-bordered">
                <thead class="table-dark">
                <tr>
                    <th>订单编码</th>
                    <th>用户账号</th>
                    <th>总金额</th>
                    <th>下单时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orderList}" var="order">
                    <tr>
                        <td>${order.orderCode}</td>
                        <td>
                                ${order.userAccount != null ? order.userAccount : '用户ID: '.concat(order.userId)}
                        </td>
                        <td>¥<fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}"><span class="status-pending">待发货</span></c:when>
                                <c:when test="${order.status == 'SHIPPED'}"><span class="status-shipped">已发货</span></c:when>
                                <c:when test="${order.status == 'DELIVERED'}"><span class="status-delivered">已送达</span></c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-buttons">
                            <c:if test="${order.status == 'PENDING'}">
                                <a href="<c:url value='/admin/orders/ship/${order.orderCode}'/>" class="btn btn-sm btn-primary" onclick="return confirm('确定将订单【${order.orderCode}】标记为已发货吗？');">
                                    <i class="bi bi-truck"></i> 标记为发货
                                </a>
                            </c:if>
                            <c:if test="${order.status == 'SHIPPED'}">
                                <span class="text-muted">等待送达</span>
                            </c:if>
                            <c:if test="${order.status == 'DELIVERED'}">
                                <span class="text-success">已完成</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

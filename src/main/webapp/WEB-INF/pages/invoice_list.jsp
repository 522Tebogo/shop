<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <title>我的发票 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 70px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-brand div.default-logo {
            background-color: #5d6bdf;
            color: #fff;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 4px;
            display: inline-block;
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
        footer.footer {
            padding: 20px 0;
            background-color: #fff;
            border-top: 1px solid #dee2e6;
            margin-top: 50px;
            color: #6c757d;
            text-align: center;
            font-size: 0.9rem;
        }
        .search-form input {
            max-width: 200px;
            margin-right: 10px;
        }
        .table thead th {
            background-color: #5d6bdf;
            color: #fff;
        }
        .table-hover tbody tr:hover {
            background-color: #e9ecef;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.85rem;
        }
        .operation-links a {
            margin-right: 6px;
        }
        .container h2 {
            color: #5d6bdf;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 5px;
            border-bottom: 3px solid #6e8efb;
            max-width: 200px;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="default-logo">嗨购商城</div>
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
                <p class="me-3 mb-0"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" width="35" height="35" alt="用户头像" class="user-avatar me-2" />
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

<div class="container">
    <h2>我的发票</h2>

    <!-- 搜索表单 -->
    <form class="search-form d-flex mb-3" action="${pageContext.request.contextPath}/invoice/search" method="get" role="search" aria-label="搜索发票">
        <input class="form-control me-2" type="text" name="invoiceNumber" placeholder="发票号码" aria-label="发票号码" />
        <input class="form-control me-2" type="text" name="orderCode" placeholder="订单号" aria-label="订单号" />
        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i> 搜索</button>
    </form>

    <!-- 发票列表 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead>
            <tr>
                <th>发票号码</th>
                <th>订单号</th>
                <th>发票抬头</th>
                <th>金额</th>
                <th>状态</th>
                <th style="min-width: 180px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${invoiceList}" var="invoice">
                <tr>
                    <td>${invoice.invoiceNumber}</td>
                    <td>${invoice.orderCode}</td>
                    <td>${invoice.title}</td>
                    <td>¥${invoice.amount}</td>
                    <td>
                        <c:choose>
                            <c:when test="${invoice.status == 0}">未开具</c:when>
                            <c:when test="${invoice.status == 1}">已开具</c:when>
                            <c:when test="${invoice.status == 2}">已删除</c:when>
                        </c:choose>
                    </td>
                    <td class="operation-links">
                        <a href="${pageContext.request.contextPath}/invoice/detail/${invoice.id}" class="btn btn-sm btn-info" title="查看">
                            <i class="bi bi-eye"></i> 查看
                        </a>
                        <c:if test="${invoice.status == 0}">
                            <a href="${pageContext.request.contextPath}/invoice/toEdit/${invoice.id}" class="btn btn-sm btn-warning" title="编辑">
                                <i class="bi bi-pencil-square"></i> 编辑
                            </a>
                            <a href="${pageContext.request.contextPath}/invoice/issue/${invoice.id}" class="btn btn-sm btn-success" title="开具">
                                <i class="bi bi-check2-circle"></i> 开具
                            </a>
                        </c:if>
                        <c:if test="${invoice.status != 2}">
                            <a href="${pageContext.request.contextPath}/invoice/delete/${invoice.id}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('确定要删除吗？')"
                               title="删除">
                                <i class="bi bi-trash"></i> 删除
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${empty invoiceList}">
        <p class="text-center text-muted">暂无发票记录</p>
    </c:if>
</div>

<!-- 底部栏 -->
<footer class="footer">
    <div class="container">&copy; 2025 嗨购商城 版权所有</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

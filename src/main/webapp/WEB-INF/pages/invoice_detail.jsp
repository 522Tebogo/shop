<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>发票详情 - 发票管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #5d6bdf;
            --secondary-color: #6e8efb;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fb;
            padding-top: 70px;
            color: #495057;
        }

        .navbar-brand .logo {
            background-color: var(--primary-color);
            color: white;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 4px;
        }

        .invoice-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            max-width: 800px;
            margin: 0 auto;
        }

        .invoice-header {
            background-color: var(--primary-color);
            color: white;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            padding: 20px;
        }

        .invoice-body {
            padding: 30px;
            background-color: white;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }

        .detail-row {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-label {
            font-weight: 600;
            color: #6c757d;
            width: 120px;
            display: inline-block;
        }

        .detail-value {
            color: #495057;
        }

        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 500;
        }

        .status-0 { background-color: #fff3cd; color: #856404; } /* 未开具 */
        .status-1 { background-color: #d4edda; color: #155724; } /* 已开具 */
        .status-2 { background-color: #f8d7da; color: #721c24; } /* 已删除 */

        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }

        .page-title {
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .page-title:after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--secondary-color);
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="logo">发票管理系统</div>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/invoice/list"><i class="bi bi-receipt"></i> 我的发票</a>
                </li>
                <c:if test="${isAdmin}">
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/dashboard"><i class="bi bi-gear"></i> 管理后台</a>
                    </li>
                </c:if>
            </ul>

            <div class="d-flex align-items-center">
                <c:if test="${not empty user}">
                    <span class="me-3"><i class="bi bi-person-check"></i> ${user.account}</span>
                    <c:choose>
                        <c:when test="${not empty user.avatar}">
                            <img src="${user.avatar}" class="user-avatar me-2">
                        </c:when>
                        <c:otherwise>
                            <div class="user-avatar bg-light d-flex align-items-center justify-content-center me-2">
                                <i class="bi bi-person"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                            我的账户
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/user/profile"><i class="bi bi-person"></i> 个人中心</a></li>
                            <li><a class="dropdown-item" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a></li>
                            <li><a class="dropdown-item" href="/invoice/list"><i class="bi bi-receipt"></i> 我的发票</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a></li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</nav>

<!-- 主要内容 -->
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-title">发票详情</h2>
        <a href="/invoice/list" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> 返回列表
        </a>
    </div>

    <div class="invoice-card">
        <div class="invoice-header">
            <h4 class="mb-0">
                <i class="bi bi-receipt"></i> 发票信息
                <span class="status-badge status-${invoice.status} float-end">
                        <c:choose>
                            <c:when test="${invoice.status == 0}">未开具</c:when>
                            <c:when test="${invoice.status == 1}">已开具</c:when>
                            <c:when test="${invoice.status == 2}">已删除</c:when>
                        </c:choose>
                    </span>
            </h4>
        </div>
        <div class="invoice-body">
            <div class="detail-row">
                <span class="detail-label">发票号码:</span>
                <span class="detail-value">${invoice.invoiceNumber}</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">订单号:</span>
                <span class="detail-value">${invoice.orderCode}</span>
            </div>

            <c:if test="${isAdmin}">
                <div class="detail-row">
                    <span class="detail-label">用户:</span>
                    <span class="detail-value">${invoice.userName}</span>
                </div>
            </c:if>

            <div class="detail-row">
                <span class="detail-label">发票抬头:</span>
                <span class="detail-value">${invoice.title}</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">税号:</span>
                <span class="detail-value">${invoice.taxNumber}</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">金额:</span>
                <span class="detail-value">¥<fmt:formatNumber value="${invoice.amount}" pattern="#,##0.00"/></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">创建时间:</span>
                <span class="detail-value"><fmt:formatDate value="${invoice.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
            </div>

            <c:if test="${invoice.status == 1}">
                <div class="detail-row">
                    <span class="detail-label">开具时间:</span>
                    <span class="detail-value"><fmt:formatDate value="${invoice.updateTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                </div>
            </c:if>

            <div class="mt-4 pt-3 border-top">
                <c:if test="${invoice.status == 0 && not isAdmin}">
                    <a href="/invoice/toEdit/${invoice.id}" class="btn btn-warning me-2">
                        <i class="bi bi-pencil"></i> 编辑发票
                    </a>
                </c:if>
                <c:if test="${invoice.status == 0 && isAdmin}">
                    <a href="/invoice/admin/issue/${invoice.id}" class="btn btn-success me-2"
                       onclick="return confirm('确定要开具此发票吗？')">
                        <i class="bi bi-check-circle"></i> 开具发票
                    </a>
                </c:if>
                <c:if test="${invoice.status == 0}">
                    <a href="/invoice/delete/${invoice.id}" class="btn btn-danger"
                       onclick="return confirm('确定要删除此发票吗？')">
                        <i class="bi bi-trash"></i> 删除发票
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- 页脚 -->
<footer class="footer mt-5 py-3 bg-light">
    <div class="container text-center">
        <span class="text-muted">&copy; 2023 发票管理系统. 保留所有权利.</span>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
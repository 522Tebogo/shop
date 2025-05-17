<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>发票列表 - 发票管理系统</title>
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
            --light-color: #f8f9fa;
            --dark-color: #343a40;
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

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .card-header {
            background-color: white;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            font-weight: 600;
        }

        .table th {
            border-top: none;
            font-weight: 600;
            color: #6c757d;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-0 { background-color: #fff3cd; color: #856404; } /* 未开具 */
        .status-1 { background-color: #d4edda; color: #155724; } /* 已开具 */
        .status-2 { background-color: #f8d7da; color: #721c24; } /* 已删除 */

        .action-btn {
            padding: 3px 8px;
            font-size: 0.85rem;
            margin-right: 5px;
        }

        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .page-title {
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 25px;
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

        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
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
        <h2 class="page-title">发票管理</h2>
        <c:if test="${not isAdmin}">
            <a href="/order/getOrder" class="btn btn-outline-primary">
                <i class="bi bi-plus-circle"></i> 申请新发票
            </a>
        </c:if>
    </div>



    <!-- 发票表格 -->
    <div class="card">
        <div class="card-header bg-white">
            <i class="bi bi-list-ul"></i> 发票列表
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <c:if test="${isAdmin}">
                            <th width="15%">用户</th>
                        </c:if>
                        <th width="15%">发票号码</th>
                        <th width="15%">订单号</th>
                        <th width="20%">发票抬头</th>
                        <th width="10%">金额</th>
                        <th width="10%">状态</th>
                        <th width="15%">创建时间</th>
                        <th width="10%">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty invoices}">
                            <c:forEach items="${invoices}" var="invoice">
                                <tr>
                                    <c:if test="${isAdmin}">
                                        <td>${invoice.userName}</td>
                                    </c:if>
                                    <td>${invoice.invoiceNumber}</td>
                                    <td>${invoice.orderCode}</td>
                                    <td>${invoice.title}</td>
                                    <td>¥<fmt:formatNumber value="${invoice.amount}" pattern="#,##0.00"/></td>
                                    <td>
                                                <span class="status-badge status-${invoice.status}">
                                                    <c:choose>
                                                        <c:when test="${invoice.status == 0}">未开具</c:when>
                                                        <c:when test="${invoice.status == 1}">已开具</c:when>
                                                        <c:when test="${invoice.status == 2}">已删除</c:when>
                                                    </c:choose>
                                                </span>
                                    </td>
                                    <td><fmt:formatDate value="${invoice.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <div class="d-flex">
                                            <a href="/invoice/${isAdmin ? 'admin/' : ''}detail/${invoice.id}"
                                               class="btn btn-sm btn-outline-primary action-btn"
                                               title="查看详情">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <c:if test="${invoice.status == 0}">
                                                <c:if test="${not isAdmin}">
                                                    <a href="/invoice/toEdit/${invoice.id}"
                                                       class="btn btn-sm btn-outline-warning action-btn"
                                                       title="编辑">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${isAdmin}">
                                                    <a href="/invoice/admin/issue/${invoice.id}"
                                                       class="btn btn-sm btn-outline-success action-btn"
                                                       title="开具"
                                                       onclick="return confirm('确定要开具此发票吗？')">
                                                        <i class="bi bi-check-circle"></i>
                                                    </a>
                                                </c:if>
                                                <a href="/invoice/delete/${invoice.id}"
                                                   class="btn btn-sm btn-outline-danger action-btn"
                                                   title="删除"
                                                   onclick="return confirm('确定要删除此发票吗？')">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="${isAdmin ? 8 : 7}" class="text-center py-4 text-muted">
                                    <i class="bi bi-exclamation-circle fs-4"></i>
                                    <p class="mt-2">没有找到符合条件的发票</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
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
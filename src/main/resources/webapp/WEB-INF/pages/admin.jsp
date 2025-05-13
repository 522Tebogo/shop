<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html >
<html>
<head>
    <base href="${base}/" />
    <title>后台管理</title>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="css/admin.css" />
</head>
<body>
<div class="container">
    <div id="header">
        <%--header--%>
            <div class="logo">
                <a href=""><img src="images/admin/logo.png" width="303" height="43" /></a>
            </div>
            <p>
                <a href="/admin/logout">退出管理</a> <a href="/admin">后台首页</a> <a href="/" target='_blank'>商城首页</a>
                <span>您好 <label class='bold'>${sessionScope.manager.account}</label></span>
            </p>
    </div>
    <div id="admin_left">
        <ul class="submenu">
            <ul class="menu">
                <li><a href="admin/category/add">增加类别</a></li>
                <li><a href="admin/category/list">类别列表</a></li>
                <li><a href="admin/goods/add">增加商品</a></li>
            </ul>
        </ul>
        <div id="copyright"></div>
    </div>

    <div id="admin_right">
        <p>欢迎使用蜗牛嗨购商城后台管理平台</p>
    </div>
    <div id="separator"></div>
</div>
</body>
</html>

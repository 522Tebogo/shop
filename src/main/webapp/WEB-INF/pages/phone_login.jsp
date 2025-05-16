<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>手机验证码登录 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            max-width: 450px;
            margin: 7% auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h2 {
            color: #5d6bdf;
            font-weight: 600;
        }
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: #5d6bdf;
            box-shadow: 0 0 0 0.2rem rgba(93, 107, 223, 0.25);
        }
        .btn-primary {
            background-color: #5d6bdf;
            border: none;
            padding: 12px;
            font-weight: 500;
            border-radius: 8px;
            width: 100%;
            margin-top: 10px;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
        }
        .btn-code {
            background-color: #6c757d;
            border: none;
            color: white;
            padding: 12px;
            font-weight: 500;
            border-radius: 8px;
            width: 100%;
        }
        .btn-code:hover {
            background-color: #5a6268;
        }
        .login-footer {
            text-align: center;
            margin-top: 20px;
        }
        .login-footer a {
            color: #5d6bdf;
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px;
            border-radius: 4px;
            display: inline-block;
            font-size: 20px;
        }
        .login-type-nav {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .login-type-nav a {
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 20px;
            color: #5d6bdf;
            text-decoration: none;
            font-weight: 500;
        }
        .login-type-nav a.active {
            background-color: #5d6bdf;
            color: white;
        }
        .code-input-group {
            display: flex;
            gap: 10px;
        }
        .code-input-group .form-control {
            flex: 1;
        }
        .code-input-group .btn-code {
            width: 140px;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="login-container">
        <div class="logo">
            <div class="default-logo">嗨购商城</div>
        </div>

        <div class="login-header">
            <h2>手机验证码登录</h2>
            <p class="text-muted">使用手机号和验证码快速登录</p>
        </div>

        <div class="login-type-nav">
            <a href="/user/login">账号密码登录</a>
            <a href="/user/login/phone" class="active">手机验证码登录</a>
            <a href="/user/login/email">邮箱验证码登录</a>
        </div>

        <!-- 显示错误消息 -->
        <c:if test="${not empty loginError}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${loginError}
            </div>
        </c:if>

        <!-- 手机验证码登录表单 -->
        <form action="/user/login/phone" method="post" id="phoneLoginForm">
            <div class="mb-3">
                <label for="phone" class="form-label">手机号</label>
                <input type="tel" class="form-control" id="phone" name="phone" placeholder="请输入11位手机号码" required pattern="^1\d{10}$">
                <div class="form-text">手机号必须是11位，且以1开头</div>
            </div>

            <div class="mb-3">
                <label for="code" class="form-label">验证码</label>
                <div class="code-input-group">
                    <input type="text" class="form-control" id="code" name="code" placeholder="请输入6位验证码" required pattern="^\d{6}$">
                    <button type="button" class="btn-code" id="sendCodeBtn">获取验证码</button>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="bi bi-box-arrow-in-right me-2"></i> 登录
            </button>
        </form>

        <div class="login-footer">
            <p>还没有账号？<a href="/user/register/phone">手机号注册</a></p>
            <p class="mt-3"><small class="text-muted">登录即表示您同意我们的服务条款和隐私政策</small></p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 定义全局变量
        var countdownTimer = null;
        var countdownNum = 60;

        // 发送验证码按钮点击事件
        $('#sendCodeBtn').click(function() {
            const phone = $('#phone').val();

            // 验证手机号格式
            if(!phone.match(/^1\d{10}$/)) {
                alert('请输入正确的手机号码');
                return;
            }

            // 立即禁用按钮
            const btn = $(this);
            btn.prop('disabled', true);
            
            // 开始倒计时
            countdownNum = 60;
            btn.text('重新发送(' + countdownNum + 's)');
            
            // 清除可能存在的旧计时器
            if(countdownTimer) {
                clearInterval(countdownTimer);
            }
            
            // 设置新的计时器
            countdownTimer = setInterval(function() {
                countdownNum--;
                btn.text('重新发送(' + countdownNum + 's)');
                
                if(countdownNum <= 0) {
                    clearInterval(countdownTimer);
                    btn.prop('disabled', false);
                    btn.text('获取验证码');
                }
            }, 1000);

            // 发送验证码请求
            $.ajax({
                url: '/verification/sendPhoneCode',
                type: 'POST',
                data: { phone: phone },
                success: function(response) {
                    if(response === 'success') {
                        alert('验证码已发送，请查看控制台输出');
                    } else {
                        alert("验证码未发送");
                        // 如果发送失败，停止倒计时，恢复按钮
                        clearInterval(countdownTimer);
                        btn.prop('disabled', false);
                        btn.text('获取验证码');
                    }
                },
                error: function() {
                    alert('发送验证码失败，请稍后再试');
                    // 如果发送失败，停止倒计时，恢复按钮
                    clearInterval(countdownTimer);
                    btn.prop('disabled', false);
                    btn.text('获取验证码');
                }
            });
        });

        // 登录类型切换功能
        $('.login-type-nav a').click(function(e) {
            const href = $(this).attr('href');
            window.location.href = href;
        });
    });
</script>
</body>
</html> 
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>绑定手机 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .profile-container {
            max-width: 900px;
            margin: 3% auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .profile-header {
            background-color: #5d6bdf;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .profile-header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 0;
        }
        .profile-nav {
            background-color: #f1f3f9;
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
        }
        .profile-nav ul {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            gap: 20px;
        }
        .profile-nav li a {
            color: #333;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 20px;
            transition: all 0.3s;
        }
        .profile-nav li a:hover {
            background-color: #e0e4f5;
        }
        .profile-nav li a.active {
            background-color: #5d6bdf;
            color: white;
        }
        .profile-content {
            padding: 30px;
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
            padding: 12px 24px;
            font-weight: 500;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
        }
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
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
            background-color: #6c757d;
            border: none;
            color: white;
            padding: 12px;
            font-weight: 500;
            border-radius: 8px;
        }
        .code-input-group .btn-code:hover {
            background-color: #5a6268;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="profile-container">
        <div class="profile-header">
            <h1>绑定手机</h1>
            <p>绑定手机号可以提高账号安全性，便于找回密码</p>
        </div>

        <div class="profile-nav">
            <ul>
                <li><a href="/user/profile"><i class="bi bi-person-fill me-2"></i>基本资料</a></li>
                <li><a href="/user/password"><i class="bi bi-key-fill me-2"></i>修改密码</a></li>
                <li><a href="/user/phone" class="active"><i class="bi bi-phone-fill me-2"></i>绑定手机</a></li>
                <li><a href="/user/email"><i class="bi bi-envelope-fill me-2"></i>绑定邮箱</a></li>
                <li><a href="/"><i class="bi bi-house-fill me-2"></i>返回首页</a></li>
            </ul>
        </div>

        <div class="profile-content">
            <!-- 显示提示消息 -->
            <div id="alertBox" class="alert" style="display: none;">
                <i class="bi bi-info-circle-fill me-2"></i> <span id="alertMessage"></span>
            </div>

            <form id="phoneForm" class="row justify-content-center">
                <div class="col-md-8">
                    <input type="hidden" id="userId" name="userId" value="${user.id}">

                    <div class="mb-4">
                        <label for="currentPhone" class="form-label">当前手机号</label>
                        <input type="text" class="form-control" id="currentPhone" value="${user.telphone}" readonly>
                    </div>

                    <div class="mb-4">
                        <label for="newPhone" class="form-label">新手机号</label>
                        <input type="tel" class="form-control" id="newPhone" name="newPhone" placeholder="请输入11位手机号码" required pattern="^1\d{10}$">
                        <div class="form-text">手机号必须是11位，且以1开头</div>
                    </div>

                    <div class="mb-4">
                        <label for="code" class="form-label">验证码</label>
                        <div class="code-input-group">
                            <input type="text" class="form-control" id="code" name="code" placeholder="请输入6位验证码" required pattern="^\d{6}$">
                            <button type="button" class="btn-code" id="sendCodeBtn">获取验证码</button>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="bi bi-check-circle-fill me-2"></i> 保存修改
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        let countdown = 0;
        let timer;

        // 发送验证码按钮点击事件
        $('#sendCodeBtn').click(function() {
            const phone = $('#newPhone').val();

            // 验证手机号格式
            if(!phone.match(/^1\d{10}$/)) {
                showAlert('danger', '请输入正确的手机号码');
                return;
            }

            // 禁用按钮，开始倒计时
            startCountdown();

            // 发送验证码请求
            $.ajax({
                url: '/verification/sendPhoneCode',
                type: 'POST',
                data: { phone: phone },
                success: function(response) {
                    if(response === 'success') {
                        showAlert('success', '验证码已发送，请查看控制台输出');
                    } else {
                        showAlert('danger', response);
                        stopCountdown();
                    }
                },
                error: function() {
                    showAlert('danger', '发送验证码失败，请稍后再试');
                    stopCountdown();
                }
            });
        });
        
        // 表单提交
        $('#phoneForm').submit(function(e) {
            e.preventDefault();
            
            const newPhone = $('#newPhone').val();
            const code = $('#code').val();
            
            // 验证手机号格式
            if(!newPhone.match(/^1\d{10}$/)) {
                showAlert('danger', '请输入正确的手机号码');
                return;
            }
            
            // 验证验证码
            if(!code.match(/^\d{6}$/)) {
                showAlert('danger', '请输入6位数字验证码');
                return;
            }
            
            // 禁用提交按钮
            $('#submitBtn').prop('disabled', true);
            
            // 发送AJAX请求
            $.ajax({
                url: '/user/phone/change',
                type: 'POST',
                data: {
                    userId: $('#userId').val(),
                    newPhone: newPhone,
                    code: code
                },
                success: function(response) {
                    if(response === 'success') {
                        showAlert('success', '手机号修改成功');
                        // 延迟刷新页面
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showAlert('danger', response);
                        $('#submitBtn').prop('disabled', false);
                    }
                },
                error: function() {
                    showAlert('danger', '请求失败，请稍后再试');
                    $('#submitBtn').prop('disabled', false);
                }
            });
        });

        // 开始倒计时
        function startCountdown() {
            const btn = $('#sendCodeBtn');
            countdown = 60;
            btn.prop('disabled', true);
            btn.text(`重新发送(${countdown}s)`);

            timer = setInterval(function() {
                countdown--;
                btn.text(`重新发送(${countdown}s)`);

                if(countdown <= 0) {
                    stopCountdown();
                }
            }, 1000);
        }

        // 停止倒计时
        function stopCountdown() {
            const btn = $('#sendCodeBtn');
            clearInterval(timer);
            btn.prop('disabled', false);
            btn.text('获取验证码');
        }
        
        // 显示提示消息
        function showAlert(type, message) {
            $('#alertBox').removeClass('alert-success alert-danger alert-warning')
                .addClass('alert-' + type)
                .find('#alertMessage').text(message);
            $('#alertBox').fadeIn();
            
            // 5秒后自动隐藏
            setTimeout(function() {
                $('#alertBox').fadeOut();
            }, 5000);
        }
    });
</script>
</body>
</html> 
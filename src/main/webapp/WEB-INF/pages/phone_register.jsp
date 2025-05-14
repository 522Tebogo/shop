<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>手机号注册 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-container {
            max-width: 500px;
            margin: 5% auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h2 {
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
        .register-footer {
            text-align: center;
            margin-top: 20px;
        }
        .register-footer a {
            color: #5d6bdf;
            text-decoration: none;
        }
        .register-footer a:hover {
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
        .register-type-nav {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .register-type-nav a {
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 20px;
            color: #5d6bdf;
            text-decoration: none;
            font-weight: 500;
        }
        .register-type-nav a.active {
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
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: -15px;
            margin-bottom: 20px;
            overflow: hidden;
            display: none;
        }
        .password-strength span {
            display: block;
            height: 100%;
            transition: width .3s;
        }
        .password-requirements {
            font-size: 0.85rem;
            margin-top: -15px;
            margin-bottom: 20px;
            color: #6c757d;
        }
        .password-requirements i {
            margin-right: 5px;
        }
        .requirement-met {
            color: #28a745;
        }
        .requirement-not-met {
            color: #dc3545;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="register-container">
        <div class="logo">
            <div class="default-logo">嗨购商城</div>
        </div>

        <div class="register-header">
            <h2>手机号注册</h2>
            <p class="text-muted">使用手机号注册嗨购商城账号</p>
        </div>

        <div class="register-type-nav">
            <a href="/user/register">常规注册</a>
            <a href="/user/register/phone" class="active">手机号注册</a>
        </div>

        <!-- 显示错误消息 -->
        <div id="alertBox" class="alert alert-danger" style="display: none;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <span id="alertMessage"></span>
        </div>

        <!-- 手机验证码注册表单 -->
        <form id="phoneRegisterForm">
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

            <div class="mb-3">
                <label for="account" class="form-label">设置用户名</label>
                <input type="text" class="form-control" id="account" name="account" placeholder="请设置6-10位用户名">
                <div class="password-requirements">
                    <div><i class="bi bi-check-circle" id="req-username-start"></i> 不能以数字开头</div>
                    <div><i class="bi bi-check-circle" id="req-username-length"></i> 长度为6-10位</div>
                    <div><i class="bi bi-check-circle" id="req-username-alphanumeric"></i> 只包含字母和数字</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">设置密码</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="请设置6-10位密码" required>
                <div class="password-requirements">
                    <div><i class="bi bi-check-circle" id="req-uppercase"></i> 以大写字母开头</div>
                    <div><i class="bi bi-check-circle" id="req-length"></i> 长度为6-10位</div>
                    <div><i class="bi bi-check-circle" id="req-alphanumeric"></i> 只包含字母和数字</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">确认密码</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
            </div>

            <div class="mb-4">
                <label for="avatarInput" class="form-label">上传头像</label>
                <input type="file" class="form-control" id="avatarInput" name="avatar" accept="image/*" max-size="10485760">
                <div class="form-text">请选择10MB以内的图片文件</div>
                <img id="showImage" class="img-thumbnail mt-2" style="max-width: 200px; max-height: 200px; display: none;" />
            </div>

            <button type="submit" class="btn btn-primary" id="registerBtn">
                <i class="bi bi-person-plus-fill me-2"></i> 注册
            </button>
        </form>

        <div class="register-footer">
            <p>已有账号？<a href="/user/login/phone">手机号登录</a></p>
            <p class="mt-3"><small class="text-muted">注册即表示您同意我们的服务条款和隐私政策</small></p>
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
            const phone = $('#phone').val();

            // 验证手机号格式
            if(!phone.match(/^1\d{10}$/)) {
                showAlert('请输入正确的手机号码');
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
                        showAlert('验证码已发送，请查看控制台输出', 'success');
                    } else {
                        showAlert(response);
                        stopCountdown();
                    }
                },
                error: function() {
                    showAlert('发送验证码失败，请稍后再试');
                    stopCountdown();
                }
            });
        });

        // 头像预览
        $('#avatarInput').change(function() {
            if (this.files && this.files[0]) {
                // 检查文件大小是否超过10MB
                const maxSize = 10 * 1024 * 1024; // 10MB
                if (this.files[0].size > maxSize) {
                    showAlert('文件大小超过限制，请选择10MB以内的图片');
                    // 清空文件输入
                    $(this).val('');
                    return;
                }
                
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#showImage').attr('src', e.target.result).css('display', 'block');
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

        // 用户名输入验证
        $('#account').on('input', function() {
            validateUsername();
        });

        // 密码输入验证
        $('#password').on('input', function() {
            validatePassword();
        });

        // 表单提交事件
        $('#phoneRegisterForm').submit(function(e) {
            e.preventDefault();

            const phone = $('#phone').val();
            const code = $('#code').val();
            const account = $('#account').val();
            const password = $('#password').val();
            const confirmPassword = $('#confirmPassword').val();

            // 验证手机号格式
            if(!phone.match(/^1\d{10}$/)) {
                showAlert('请输入正确的手机号码');
                return;
            }

            // 验证验证码格式
            if(!code.match(/^\d{6}$/)) {
                showAlert('请输入6位数字验证码');
                return;
            }
            
            // 验证用户名格式（如果有填写）
            if(account && !validateUsername()) {
                showAlert('用户名格式不正确，只能包含字母和数字，且不能以数字开头，6~10位');
                return;
            }

            // 验证密码格式
            if(!validatePassword()) {
                showAlert('密码格式不正确，必须以大写字母开头，长度6-10位，只包含字母和数字');
                return;
            }

            // 验证两次密码输入是否一致
            if(password !== confirmPassword) {
                showAlert('两次输入的密码不一致');
                return;
            }

            // 禁用提交按钮
            $('#registerBtn').prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 注册中...');

            // 创建FormData对象
            const formData = new FormData(this);
            
            // 提交注册请求
            $.ajax({
                url: '/user/register/phone',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if(response === 'success') {
                        showAlert('注册成功！即将跳转到登录页面...', 'success');
                        setTimeout(function() {
                            window.location.href = '/user/login/phone';
                        }, 2000);
                    } else {
                        showAlert(response);
                        $('#registerBtn').prop('disabled', false).html('<i class="bi bi-person-plus-fill me-2"></i> 注册');
                    }
                },
                error: function() {
                    showAlert('注册失败，请稍后再试');
                    $('#registerBtn').prop('disabled', false).html('<i class="bi bi-person-plus-fill me-2"></i> 注册');
                }
            });
        });

        // 验证用户名格式
        function validateUsername() {
            const username = $('#account').val();
            let isValid = true;
            
            // 如果用户名为空，不进行验证
            if (!username) {
                return true;
            }
            
            // 验证不能以数字开头
            const notStartWithNumber = /^[^0-9]/.test(username);
            updateRequirement('req-username-start', notStartWithNumber);
            isValid = isValid && notStartWithNumber;
            
            // 验证长度为6-10位
            const validLength = username.length >= 6 && username.length <= 10;
            updateRequirement('req-username-length', validLength);
            isValid = isValid && validLength;
            
            // 验证只包含字母和数字
            const alphanumericOnly = /^[a-zA-Z0-9]+$/.test(username);
            updateRequirement('req-username-alphanumeric', alphanumericOnly);
            isValid = isValid && alphanumericOnly;
            
            return isValid;
        }

        // 验证密码格式
        function validatePassword() {
            const password = $('#password').val();
            let isValid = true;

            // 验证以大写字母开头
            const startsWithUppercase = /^[A-Z]/.test(password);
            updateRequirement('req-uppercase', startsWithUppercase);
            isValid = isValid && startsWithUppercase;

            // 验证长度为6-10位
            const validLength = password.length >= 6 && password.length <= 10;
            updateRequirement('req-length', validLength);
            isValid = isValid && validLength;

            // 验证只包含字母和数字
            const alphanumericOnly = /^[a-zA-Z0-9]+$/.test(password);
            updateRequirement('req-alphanumeric', alphanumericOnly);
            isValid = isValid && alphanumericOnly;

            return isValid;
        }

        // 更新密码要求状态
        function updateRequirement(id, isMet) {
            const element = $('#' + id);
            if(isMet) {
                element.removeClass('bi-x-circle requirement-not-met').addClass('bi-check-circle requirement-met');
            } else {
                element.removeClass('bi-check-circle requirement-met').addClass('bi-x-circle requirement-not-met');
            }
        }

        // 显示提示信息
        function showAlert(message, type = 'danger') {
            const alertBox = $('#alertBox');
            const alertMessage = $('#alertMessage');

            alertBox.removeClass('alert-danger alert-success').addClass('alert-' + type);
            alertMessage.text(message);
            alertBox.fadeIn();

            // 3秒后自动隐藏
            setTimeout(function() {
                alertBox.fadeOut();
            }, 3000);
        }

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
    });
</script>
</body>
</html> 
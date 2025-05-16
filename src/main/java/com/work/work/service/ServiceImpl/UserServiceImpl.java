package com.work.work.service.ServiceImpl;

import com.work.work.entity.User;
import com.work.work.mapper.UserMapper;
import com.work.work.service.UserService;
import com.work.work.service.VerificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private VerificationService verificationService;

    @Override
    public User login(String account, String password, HttpSession session) {
        // 参数校验
        if (account == null || password == null) {
            session.setAttribute("msg", "账号和密码不能为空");
            return null;
        }
        
        // 验证用户名格式
        if (!isValidUsername(account)) {
            session.setAttribute("msg", "用户名格式不正确");
            return null;
        }
        
        // 验证密码格式
        if (!isValidPassword(password)) {
            session.setAttribute("msg", "密码格式不正确");
            return null;
        }
        
        User user = userMapper.getUserByAccount(account);
        if (user == null) {
            System.out.println("用户不存在，请先注册！");
            session.setAttribute("msg", "用户不存在，请先注册！");
            return null;
        }
        
        String pass = DigestUtils.md5DigestAsHex(password.getBytes());
        System.out.println("输入密码MD5: " + pass);
        System.out.println("数据库密码: " + user.getPassword());
        
        if (user.getPassword().equals(pass)) {
            System.out.println("密码正确");
            return user;
        } else {
            session.setAttribute("msg", "账号或密码不正确");
            return null;
        }
    }
    
    @Override
    public User loginByPhone(String phone, String code, HttpSession session) {
        // 参数校验
        if (phone == null || code == null) {
            session.setAttribute("msg", "手机号和验证码不能为空");
            return null;
        }
        
        // 验证手机号格式
        if (!verificationService.isValidPhone(phone)) {
            session.setAttribute("msg", "手机号格式不正确");
            return null;
        }
        
        // 验证验证码
        if (!verificationService.verifyCode(phone, code)) {
            session.setAttribute("msg", "验证码错误或已过期");
            return null;
        }
        
        // 查询用户
        User user = userMapper.getUserByPhone(phone);
        
        // 如果用户不存在，需要注册
        if (user == null) {
            session.setAttribute("msg", "该手机号未注册，请先注册");
            session.setAttribute("verified_phone", phone); // 标记已验证的手机号，用于注册
            return null;
        }
        
        // 使验证码失效
        verificationService.invalidateCode(phone, code);
        
        return user;
    }
    
    @Override
    public User loginByEmail(String email, String code, HttpSession session) {
        // 参数校验
        if (email == null || code == null) {
            session.setAttribute("msg", "邮箱和验证码不能为空");
            return null;
        }
        
        // 验证邮箱格式
        if (!verificationService.isValidEmail(email)) {
            session.setAttribute("msg", "邮箱格式不正确");
            return null;
        }
        
        // 验证验证码
        if (!verificationService.verifyCode(email, code)) {
            session.setAttribute("msg", "验证码错误或已过期");
            return null;
        }
        
        // 查询用户
        User user = userMapper.getUserByEmail(email);
        
        // 如果用户不存在，需要注册
        if (user == null) {
            session.setAttribute("msg", "该邮箱未注册，请先注册");
            session.setAttribute("verified_email", email); // 标记已验证的邮箱，用于注册
            return null;
        }
        
        // 使验证码失效
        verificationService.invalidateCode(email, code);
        
        return user;
    }
    
    @Override
    public boolean registerByPhone(String phone, String code, String password, String account, MultipartFile avatar, HttpSession session) throws IOException {
        // 参数校验
        if (phone == null || code == null || password == null) {
            session.setAttribute("msg", "手机号、验证码和密码不能为空");
            return false;
        }
        
        // 验证手机号格式
        if (!verificationService.isValidPhone(phone)) {
            session.setAttribute("msg", "手机号格式不正确");
            return false;
        }
        
        // 验证验证码，除非session中已经有验证通过的手机号
        String verifiedPhone = (String) session.getAttribute("verified_phone");
        if (!phone.equals(verifiedPhone)) {
            if (!verificationService.verifyCode(phone, code)) {
                session.setAttribute("msg", "验证码错误或已过期");
                return false;
            }
        }
        
        // 验证密码格式
        if (!isValidPassword(password)) {
            session.setAttribute("msg", "密码格式不正确");
            return false;
        }
        
        // 检查手机号是否已注册
        User existingUser = userMapper.getUserByPhone(phone);
        if (existingUser != null) {
            session.setAttribute("msg", "该手机号已注册");
            return false;
        }
        
        // 验证用户名格式（如果提供）
        if (account != null && !account.isEmpty()) {
            if (!isValidUsername(account)) {
                session.setAttribute("msg", "用户名格式不正确");
                return false;
            }
            
            // 检查用户名是否已存在
            if (isUsernameExists(account)) {
                session.setAttribute("msg", "用户名已存在");
                return false;
            }
        } else {
            // 生成用户名
            account = "user_" + UUID.randomUUID().toString().substring(0, 8);
        }
        
        // 处理头像上传
        String avatarPath = "";
        if (avatar != null && !avatar.isEmpty() && avatar.getSize() > 0) {
            avatarPath = this.saveAvatar(avatar);
        } else {
            // 设置默认头像路径
            avatarPath = "/static/images/default_avatar.png";
        }
        
        // 创建新用户
        User newUser = new User();
        newUser.setAccount(account);
        newUser.setPassword(DigestUtils.md5DigestAsHex(password.getBytes()));
        newUser.setTelphone(phone);
        newUser.setNickname("用户" + phone.substring(phone.length() - 4));
        newUser.setPoints(0);
        newUser.setMoney(BigDecimal.valueOf(0.0));
        newUser.setRegTime(LocalDateTime.now());
        newUser.setStatus("Y");
        newUser.setAvatar(avatarPath);
        
        // 保存用户
        boolean result = userMapper.insert(newUser) > 0;
        
        if (result) {
            // 使验证码失效
            verificationService.invalidateCode(phone, code);
            session.removeAttribute("verified_phone");
        }
        
        return result;
    }

    @Override
    public boolean insertUser(String account, String password, String telphone, String email, MultipartFile avatar) throws IOException {
        // 参数校验
        if (account == null || password == null) {
            return false;
        }
        
        // 验证用户名格式
        if (!isValidUsername(account)) {
            return false;
        }
        
        // 验证密码格式
        if (!isValidPassword(password)) {
            return false;
        }
        
        // 验证手机号格式（如果有）
        if (telphone != null && !telphone.isEmpty() && !verificationService.isValidPhone(telphone)) {
            return false;
        }
        
        // 验证邮箱格式（如果有）
        if (email != null && !email.isEmpty() && !verificationService.isValidEmail(email)) {
            return false;
        }
        
        // 检查用户名是否已存在
        User curUser = userMapper.getUserByAccount(account);
        if (curUser != null) {
            return false;
        }
        
        // 检查手机号是否已存在
        if (telphone != null && !telphone.isEmpty()) {
            User phoneUser = userMapper.getUserByPhone(telphone);
            if (phoneUser != null) {
                return false;
            }
        }
        
        // 检查邮箱是否已存在
        if (email != null && !email.isEmpty()) {
            User emailUser = userMapper.getUserByEmail(email);
            if (emailUser != null) {
                return false;
            }
        }
        
        String avatarPath = "";
        if (avatar != null && !avatar.isEmpty() && avatar.getSize() > 0) {
            avatarPath = this.saveAvatar(avatar);
        } else {
            // 设置默认头像路径
            avatarPath = "/static/images/default_avatar.png";
        }
        
        User newUser = new User();
        newUser.setAccount(account);
        newUser.setPassword(DigestUtils.md5DigestAsHex(password.getBytes()));
        newUser.setTelphone(telphone);
        newUser.setEmail(email);
        newUser.setNickname(account); // 默认昵称为用户名
        newUser.setPoints(0);
        newUser.setMoney(BigDecimal.valueOf(0.0));
        newUser.setRegTime(LocalDateTime.now());
        newUser.setStatus("Y");
        newUser.setAvatar(avatarPath);
        
        return userMapper.insert(newUser) > 0;
    }
    
    @Override
    public boolean isValidUsername(String username) {
        // 只能包含字母和数字，且不能以数字开头，6~10位
        return username != null && Pattern.matches("^[a-zA-Z][a-zA-Z0-9]{5,9}$", username);
    }
    
    @Override
    public boolean isValidPassword(String password) {
        // 只能包含字母和数字，且必需以大写字母开头，6~10位
        return password != null && Pattern.matches("^[A-Z][a-zA-Z0-9]{5,9}$", password);
    }

    @Override
    public boolean isUsernameExists(String username) {
        // 直接查询数据库检查用户名是否存在
        User user = userMapper.getUserByAccount(username);
        return user != null;
    }

    @Override
    public User getUserByPhone(String phone) {
        return userMapper.getUserByPhone(phone);
    }
    
    @Override
    public User getUserByEmail(String email) {
        return userMapper.getUserByEmail(email);
    }

    @Override
    public String saveAvatar(MultipartFile file) throws IOException {
        // 创建上传目录 - 保存到webapp目录下的static/images/avatars
        String uploadDir = "src/main/webapp/static/images/avatars";
        Path uploadPath = Paths.get(uploadDir);
        
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            System.out.println("创建头像目录: " + uploadPath.toAbsolutePath());
        }
        
        // 生成唯一文件名
        String uniqueFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path filePath = uploadPath.resolve(uniqueFileName);
        
        // 保存文件
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("保存头像文件成功: " + filePath.toAbsolutePath());
        
        // 返回相对路径，确保前端可以正确访问
        return "/static/images/avatars/" + uniqueFileName;
    }
    
    @Override
    public boolean updateUserInfo(Integer userId, Map<String, String> userInfo, HttpSession session) throws IOException {
        if (userId == null || userInfo == null) {
            session.setAttribute("msg", "参数错误");
            return false;
        }
        
        User user = new User();
        user.setId(userId);
        
        // 更新昵称
        if (userInfo.containsKey("nickname")) {
            String nickname = userInfo.get("nickname");
            if (nickname != null && !nickname.isEmpty()) {
                user.setNickname(nickname);
            }
        }
        
        // 更新用户名
        if (userInfo.containsKey("account")) {
            String account = userInfo.get("account");
            if (account != null && !account.isEmpty()) {
                user.setAccount(account);
            }
        }
        
        // 更新头像
        if (userInfo.containsKey("avatar")) {
            String avatar = userInfo.get("avatar");
            if (avatar != null && !avatar.isEmpty()) {
                user.setAvatar(avatar);
            }
        }
        
        // 更新用户信息
        boolean updateResult = userMapper.updateUser(user) > 0;
        
        // 如果更新成功，同时更新当前会话中的用户对象
        if (updateResult) {
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser != null && sessionUser.getId().equals(userId)) {
                // 如果有更新头像，则更新会话中的头像
                if (user.getAvatar() != null) {
                    sessionUser.setAvatar(user.getAvatar());
                }
                
                // 如果有更新昵称，则更新会话中的昵称
                if (user.getNickname() != null) {
                    sessionUser.setNickname(user.getNickname());
                }
                
                // 如果有更新用户名，则更新会话中的用户名
                if (user.getAccount() != null) {
                    sessionUser.setAccount(user.getAccount());
                }
                
                // 更新会话中的用户信息
                session.setAttribute("user", sessionUser);
            }
        }
        
        return updateResult;
    }
    
    @Override
    public boolean changePassword(Integer userId, String oldPassword, String newPassword, HttpSession session) {
        if (userId == null || oldPassword == null || newPassword == null) {
            session.setAttribute("msg", "参数错误");
            return false;
        }
        
        // 验证新密码格式
        if (!isValidPassword(newPassword)) {
            session.setAttribute("msg", "新密码格式不正确，密码必须以大写字母开头，6-10位，只能包含字母和数字");
            return false;
        }
        
        // 获取用户信息
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getId().equals(userId)) {
            session.setAttribute("msg", "用户未登录或无权限");
            return false;
        }
        
        // 验证旧密码
        String oldPassMd5 = DigestUtils.md5DigestAsHex(oldPassword.getBytes());
        if (!user.getPassword().equals(oldPassMd5)) {
            session.setAttribute("msg", "原密码错误");
            return false;
        }
        
        // 加密新密码
        String newPassMd5 = DigestUtils.md5DigestAsHex(newPassword.getBytes());
        
        // 更新密码
        boolean result = userMapper.updatePassword(userId, newPassMd5) > 0;
        
        if (result) {
            // 更新session中的用户信息
            user.setPassword(newPassMd5);
            session.setAttribute("user", user);
        }
        
        return result;
    }
    
    @Override
    public boolean changePhone(Integer userId, String newPhone, String code, HttpSession session) {
        if (userId == null || newPhone == null || code == null) {
            session.setAttribute("msg", "参数错误");
            return false;
        }
        
        // 验证手机号格式
        if (!verificationService.isValidPhone(newPhone)) {
            session.setAttribute("msg", "手机号格式不正确");
            return false;
        }
        
        // 验证验证码
        if (!verificationService.verifyCode(newPhone, code)) {
            session.setAttribute("msg", "验证码错误或已过期");
            return false;
        }
        
        // 检查手机号是否已被其他用户使用
        User existingUser = userMapper.getUserByPhone(newPhone);
        if (existingUser != null && !existingUser.getId().equals(userId)) {
            session.setAttribute("msg", "该手机号已被其他用户绑定");
            return false;
        }
        
        // 更新手机号
        boolean result = userMapper.updatePhone(userId, newPhone) > 0;
        
        if (result) {
            // 使验证码失效
            verificationService.invalidateCode(newPhone, code);
            
            // 更新session中的用户信息
            User user = (User) session.getAttribute("user");
            if (user != null && user.getId().equals(userId)) {
                user.setTelphone(newPhone);
                session.setAttribute("user", user);
            }
        }
        
        return result;
    }
    
    @Override
    public boolean changeEmail(Integer userId, String newEmail, String code, HttpSession session) {
        if (userId == null || newEmail == null || code == null) {
            session.setAttribute("msg", "参数错误");
            return false;
        }
        
        // 验证邮箱格式
        if (!verificationService.isValidEmail(newEmail)) {
            session.setAttribute("msg", "邮箱格式不正确");
            return false;
        }
        
        // 验证验证码
        if (!verificationService.verifyCode(newEmail, code)) {
            session.setAttribute("msg", "验证码错误或已过期");
            return false;
        }
        
        // 检查邮箱是否已被其他用户使用
        User existingUser = userMapper.getUserByEmail(newEmail);
        if (existingUser != null && !existingUser.getId().equals(userId)) {
            session.setAttribute("msg", "该邮箱已被其他用户绑定");
            return false;
        }
        
        // 更新邮箱
        boolean result = userMapper.updateEmail(userId, newEmail) > 0;
        
        if (result) {
            // 使验证码失效
            verificationService.invalidateCode(newEmail, code);
            
            // 更新session中的用户信息
            User user = (User) session.getAttribute("user");
            if (user != null && user.getId().equals(userId)) {
                user.setEmail(newEmail);
                session.setAttribute("user", user);
            }
        }
        
        return result;
    }
}


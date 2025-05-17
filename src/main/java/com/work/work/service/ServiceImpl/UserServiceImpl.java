package com.work.work.service.ServiceImpl;

import com.work.work.entity.Admin;
import com.work.work.entity.User;
import com.work.work.mapper.AdminMapper;
import com.work.work.mapper.UserMapper;
import com.work.work.service.UserService;
import com.work.work.service.VerificationService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
public class UserServiceImpl implements UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private VerificationService verificationService;

    @Autowired
    private AdminMapper adminMapper; // 注入 AdminMapper

    @Value("${myapp.upload-dir.avatars:/tmp/uploads/avatars}")
    private String avatarUploadDir;

    private static final String USER_STATUS_ACTIVE = "Y";
    private static final String USER_STATUS_FROZEN = "F";
    private static final String USER_STATUS_BLACKLISTED = "B";
    private static final String USER_STATUS_DELETED = "D";
    private static final String USER_STATUS_UPGRADED = "M"; // 新增状态：已升级为管理员

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
            logger.info("Login attempt for non-existent user account: {}", account);
            session.setAttribute("msg", "用户不存在，请先注册！");
            return null;
        }

        String pass = DigestUtils.md5DigestAsHex(password.getBytes());
        logger.debug("Input password MD5 for account {}: {}", account, pass);
        logger.debug("Database password MD5 for account {}: {}", account, user.getPassword());

        if (user.getPassword().equals(pass)) {
            // 密码正确，现在检查用户状态
            if (USER_STATUS_ACTIVE.equals(user.getStatus())) {
                logger.info("Password correct and user status active for account: {}", account);
                return user; // 允许登录
            } else if (USER_STATUS_FROZEN.equals(user.getStatus())) {
                logger.warn("Login attempt for frozen account: {}", account);
                session.setAttribute("msg", "您的账户已被冻结，请联系管理员。");
                return null;
            } else if (USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
                logger.warn("Login attempt for blacklisted account: {}", account);
                session.setAttribute("msg", "您的账户已被列入黑名单，无法登录。");
                return null;
            } else if (USER_STATUS_DELETED.equals(user.getStatus())) {
                logger.warn("Login attempt for deleted account: {}", account);
                session.setAttribute("msg", "您的账户已被删除。");
                return null;
            } else if (USER_STATUS_UPGRADED.equals(user.getStatus())) {
                logger.warn("Login attempt for upgraded admin account {} via user login.", account);
                session.setAttribute("msg", "管理员账号请从管理员入口登录。");
                return null;
            } else {
                logger.warn("Login attempt for account {} with unknown status: {}", account, user.getStatus());
                session.setAttribute("msg", "账户状态异常，请联系管理员。");
                return null;
            }
        } else {
            logger.warn("Incorrect password for account: {}", account);
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
            logger.warn("Phone login attempt with invalid code for phone: {}", phone);
            session.setAttribute("msg", "验证码错误或已过期");
            return null;
        }

        // 查询用户
        User user = userMapper.getUserByPhone(phone);

        if (user == null) {
            logger.info("Phone login attempt for non-existent phone: {}", phone);
            session.setAttribute("msg", "该手机号未注册，请先注册");
            session.setAttribute("verified_phone", phone); // 标记已验证的手机号，用于注册
            return null;
        }

        // 用户存在，现在检查用户状态
        if (USER_STATUS_ACTIVE.equals(user.getStatus())) {
            logger.info("Phone login successful and user status active for phone: {}", phone);
            verificationService.invalidateCode(phone, code); // 状态正常，使验证码失效
            return user; // 允许登录
        } else if (USER_STATUS_FROZEN.equals(user.getStatus())) {
            logger.warn("Phone login attempt for frozen account with phone: {}", phone);
            session.setAttribute("msg", "您的账户已被冻结，请联系管理员。");
            // verificationService.invalidateCode(phone, code); // 考虑是否在此处失效验证码
            return null;
        } else if (USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            logger.warn("Phone login attempt for blacklisted account with phone: {}", phone);
            session.setAttribute("msg", "您的账户已被列入黑名单，无法登录。");
            return null;
        } else if (USER_STATUS_DELETED.equals(user.getStatus())) {
            logger.warn("Phone login attempt for deleted account with phone: {}", phone);
            session.setAttribute("msg", "您的账户已被删除。");
            return null;
        } else if (USER_STATUS_UPGRADED.equals(user.getStatus())) {
            logger.warn("Phone login attempt for upgraded admin account {} via user login.", user.getAccount());
            session.setAttribute("msg", "管理员账号请从管理员入口登录。");
            return null;
        } else {
            logger.warn("Phone login attempt for account with phone {} and unknown status: {}", phone, user.getStatus());
            session.setAttribute("msg", "账户状态异常，请联系管理员。");
            return null;
        }
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
            logger.warn("Email login attempt with invalid code for email: {}", email);
            session.setAttribute("msg", "验证码错误或已过期");
            return null;
        }

        // 查询用户
        User user = userMapper.getUserByEmail(email);

        if (user == null) {
            logger.info("Email login attempt for non-existent email: {}", email);
            session.setAttribute("msg", "该邮箱未注册，请先注册");
            session.setAttribute("verified_email", email); // 标记已验证的邮箱，用于注册
            return null;
        }

        // 用户存在，现在检查用户状态
        if (USER_STATUS_ACTIVE.equals(user.getStatus())) {
            logger.info("Email login successful and user status active for email: {}", email);
            verificationService.invalidateCode(email, code); // 状态正常，使验证码失效
            return user; // 允许登录
        } else if (USER_STATUS_FROZEN.equals(user.getStatus())) {
            logger.warn("Email login attempt for frozen account with email: {}", email);
            session.setAttribute("msg", "您的账户已被冻结，请联系管理员。");
            return null;
        } else if (USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            logger.warn("Email login attempt for blacklisted account with email: {}", email);
            session.setAttribute("msg", "您的账户已被列入黑名单，无法登录。");
            return null;
        } else if (USER_STATUS_DELETED.equals(user.getStatus())) {
            logger.warn("Email login attempt for deleted account with email: {}", email);
            session.setAttribute("msg", "您的账户已被删除。");
            return null;
        } else if (USER_STATUS_UPGRADED.equals(user.getStatus())) {
            logger.warn("Email login attempt for upgraded admin account {} via user login.", user.getAccount());
            session.setAttribute("msg", "管理员账号请从管理员入口登录。");
            return null;
        } else {
            logger.warn("Email login attempt for account with email {} and unknown status: {}", email, user.getStatus());
            session.setAttribute("msg", "账户状态异常，请联系管理员。");
            return null;
        }
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
        if (!phone.equals(verifiedPhone)) { // 如果当前手机号和session中已验证的不同，则需要重新验证
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
            avatarPath = this.saveAvatar(avatar, session);
            if (avatarPath == null) { // 头像保存失败
                session.setAttribute("msg", "头像上传失败，请重试");
                return false;
            }
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
        newUser.setStatus(USER_STATUS_ACTIVE); // 新注册用户默认为激活状态
        newUser.setAvatar(avatarPath);

        // 保存用户
        boolean result = userMapper.insert(newUser) > 0;

        if (result) {
            logger.info("New user registered by phone: {}, account: {}", phone, account);
            // 使验证码失效 (不论是否从session中读取的已验证手机号，都应该使当前使用的code失效)
            verificationService.invalidateCode(phone, code);
            session.removeAttribute("verified_phone"); // 清除session中的标记
        } else {
            logger.error("Failed to register user by phone: {}", phone);
        }

        return result;
    }

    @Override
    public boolean insertUser(String account, String password, String telphone, String email, MultipartFile avatar) throws IOException {
        // 参数校验
        if (account == null || password == null) {
            logger.warn("Attempted to insert user with null account or password.");
            return false;
        }

        // 验证用户名格式
        if (!isValidUsername(account)) {
            logger.warn("Invalid username format during user insertion: {}", account);
            return false;
        }

        // 验证密码格式
        if (!isValidPassword(password)) {
            logger.warn("Invalid password format during user insertion for account: {}", account);
            return false;
        }

        // 验证手机号格式（如果有）
        if (telphone != null && !telphone.isEmpty() && !verificationService.isValidPhone(telphone)) {
            logger.warn("Invalid phone format during user insertion: {}", telphone);
            return false;
        }

        // 验证邮箱格式（如果有）
        if (email != null && !email.isEmpty() && !verificationService.isValidEmail(email)) {
            logger.warn("Invalid email format during user insertion: {}", email);
            return false;
        }

        // 检查用户名是否已存在
        if (isUsernameExists(account)) {
            logger.warn("Attempted to insert user with existing account: {}", account);
            return false;
        }

        // 检查手机号是否已存在
        if (telphone != null && !telphone.isEmpty()) {
            User phoneUser = userMapper.getUserByPhone(telphone);
            if (phoneUser != null) {
                logger.warn("Attempted to insert user with existing phone: {}", telphone);
                return false;
            }
        }

        // 检查邮箱是否已存在
        if (email != null && !email.isEmpty()) {
            User emailUser = userMapper.getUserByEmail(email);
            if (emailUser != null) {
                logger.warn("Attempted to insert user with existing email: {}", email);
                return false;
            }
        }

        String avatarPath = "";
        if (avatar != null && !avatar.isEmpty() && avatar.getSize() > 0) {
            avatarPath = this.saveAvatar(avatar, null);
            if (avatarPath == null) { // 头像保存失败
                logger.error("Avatar upload failed during user insertion for account: {}", account);
                // 可以根据业务需求决定是否因为头像上传失败而中断注册
                // return false;
            }
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
        newUser.setStatus(USER_STATUS_ACTIVE); // 新注册用户默认为激活状态
        newUser.setAvatar(avatarPath);

        boolean result = userMapper.insert(newUser) > 0;
        if(result){
            logger.info("New user inserted successfully: Account {}", account);
        } else {
            logger.error("Failed to insert new user: Account {}", account);
        }
        return result;
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
    public String saveAvatar(MultipartFile file, HttpSession session) {
        if (file == null || file.isEmpty()) {
            logger.warn("Attempted to save null or empty avatar file.");
            return null;
        }

        try {
            // 检查文件类型是否为图片
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                logger.warn("Invalid avatar file type: {}. Original filename: {}", contentType, file.getOriginalFilename());
                return null;
            }

            // 检查文件大小（10MB）
            long maxSize = 10 * 1024 * 1024; // 10MB
            if (file.getSize() > maxSize) {
                logger.warn("Avatar file too large: {} bytes. Original filename: {}", file.getSize(), file.getOriginalFilename());
                return null;
            }

            // 获取文件扩展名
            String originalFilename = file.getOriginalFilename();
            String fileExtension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
                // 检查扩展名是否合法
                if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif").contains(fileExtension)) {
                    logger.warn("Invalid file extension: {}. Original filename: {}", fileExtension, originalFilename);
                    return null;
                }
            } else {
                logger.warn("No file extension found. Original filename: {}", originalFilename);
                return null;
            }

            // 创建上传目录
            Path uploadPath = Paths.get(avatarUploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                logger.info("Created avatar upload directory: {}", uploadPath.toAbsolutePath());
            }

            // 生成唯一文件名
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            Path filePath = uploadPath.resolve(uniqueFileName);

            // 保存文件
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            logger.info("Avatar file saved successfully: {}. Original: {}", filePath.toAbsolutePath(), originalFilename);

            // 只有当session不为null时才尝试删除旧头像
            if (session != null) {
                // 删除旧头像文件（如果存在且不是默认头像）
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null && currentUser.getAvatar() != null
                        && !currentUser.getAvatar().equals("/static/images/default_avatar.png")) {
                    try {
                        String oldAvatarPath = currentUser.getAvatar();
                        if (oldAvatarPath.startsWith("/static/images/avatars/")) {
                            String oldFileName = oldAvatarPath.substring(oldAvatarPath.lastIndexOf("/") + 1);
                            Path oldFilePath = uploadPath.resolve(oldFileName);
                            Files.deleteIfExists(oldFilePath);
                            logger.info("Old avatar file deleted: {}", oldFilePath);
                        }
                    } catch (Exception e) {
                        logger.warn("Failed to delete old avatar file", e);
                    }
                }
            }

            // 返回相对路径
            return "/static/images/avatars/" + uniqueFileName;

        } catch (IOException e) {
            logger.error("Failed to save avatar file. Original filename: {}", file.getOriginalFilename(), e);
            return null;
        }
    }


    @Override
    public boolean updateUserInfo(Integer userId, Map<String, String> userInfo, HttpSession session) {
        if (userId == null || userInfo == null) {
            session.setAttribute("msg", "参数错误");
            return false;
        }

        User userToUpdate = userMapper.getUserById(userId);
        if (userToUpdate == null) {
            session.setAttribute("msg", "用户不存在");
            return false;
        }

        boolean changed = false;

        // 更新昵称
        if (userInfo.containsKey("nickname")) {
            String nickname = userInfo.get("nickname");
            if (nickname != null && !nickname.trim().isEmpty() && !nickname.equals(userToUpdate.getNickname())) {
                userToUpdate.setNickname(nickname.trim());
                changed = true;
            }
        }

        // 更新用户名 (account)
        if (userInfo.containsKey("account")) {
            String newAccount = userInfo.get("account");
            if (newAccount != null && !newAccount.trim().isEmpty() && !newAccount.equals(userToUpdate.getAccount())) {
                // 验证新用户名格式
                if (!isValidUsername(newAccount)) {
                    session.setAttribute("msg", "新用户名格式不正确");
                    return false;
                }
                // 检查新用户名是否已存在 (排除自己)
                User existingUser = userMapper.getUserByAccount(newAccount);
                if (existingUser != null && !existingUser.getId().equals(userId)) {
                    session.setAttribute("msg", "新用户名已存在");
                    return false;
                }
                userToUpdate.setAccount(newAccount.trim());
                changed = true;
            }
        }

        // 更新头像路径
        if (userInfo.containsKey("avatar")) {
            String avatarPath = userInfo.get("avatar");
            if (avatarPath != null && !avatarPath.isEmpty() && !avatarPath.equals(userToUpdate.getAvatar())) {
                userToUpdate.setAvatar(avatarPath);
                changed = true;
            }
        }

        if (changed) {
            int result = userMapper.updateUser(userToUpdate);
            if (result > 0) {
                logger.info("User info updated for ID: {}", userId);
                // 更新session中的用户信息
                User updatedUserFromSession = (User) session.getAttribute("user");
                if (updatedUserFromSession != null && updatedUserFromSession.getId().equals(userId)) {
                    if (userInfo.containsKey("nickname")) updatedUserFromSession.setNickname(userToUpdate.getNickname());
                    if (userInfo.containsKey("account")) updatedUserFromSession.setAccount(userToUpdate.getAccount());
                    if (userInfo.containsKey("avatar")) updatedUserFromSession.setAvatar(userToUpdate.getAvatar());
                    session.setAttribute("user", updatedUserFromSession);
                }
                return true;
            } else {
                logger.error("Failed to update user info for ID: {}", userId);
                session.setAttribute("msg", "用户信息更新失败");
                return false;
            }
        }

        logger.info("No changes to update for user ID: {}", userId);
        return true;
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

        // 获取用户信息 (应该从数据库获取最新信息，而不是session中的旧信息)
        User user = userMapper.getUserById(userId);
        if (user == null) {
            session.setAttribute("msg", "用户不存在"); // 或者更通用的"操作失败"
            return false;
        }

        // 确保操作的是当前登录用户 (如果业务逻辑需要)
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null || !sessionUser.getId().equals(userId)) {
            logger.warn("Attempt to change password for user {} by unauthenticated or different user in session.", userId);
            session.setAttribute("msg", "无权限操作或会话已过期");
            return false;
        }


        // 验证旧密码
        String oldPassMd5 = DigestUtils.md5DigestAsHex(oldPassword.getBytes());
        if (!user.getPassword().equals(oldPassMd5)) {
            session.setAttribute("msg", "原密码错误");
            return false;
        }

        // 检查新旧密码是否相同
        if (oldPassword.equals(newPassword)) {
            session.setAttribute("msg", "新密码不能与旧密码相同");
            return false;
        }

        // 加密新密码
        String newPassMd5 = DigestUtils.md5DigestAsHex(newPassword.getBytes());

        // 更新密码
        int result = userMapper.updatePassword(userId, newPassMd5);

        if (result > 0) {
            logger.info("Password changed successfully for user ID: {}", userId);
            // 更新session中的用户密码（如果仍然需要保持用户登录状态）
            // 或者直接让用户重新登录
            sessionUser.setPassword(newPassMd5);
            session.setAttribute("user", sessionUser);
            return true;
        } else {
            logger.error("Failed to change password for user ID: {}", userId);
            session.setAttribute("msg", "密码修改失败");
            return false;
        }
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

        // 检查新手机号是否与旧手机号相同
        User currentUser = userMapper.getUserById(userId);
        if (currentUser != null && newPhone.equals(currentUser.getTelphone())) {
            session.setAttribute("msg", "新手机号与当前手机号相同，无需更改");
            verificationService.invalidateCode(newPhone, code); // 即使未更改，也使验证码失效
            return true; // 或 false，取决于业务逻辑，这里假设相同也算操作完成
        }


        // 更新手机号
        int result = userMapper.updatePhone(userId, newPhone);

        if (result > 0) {
            logger.info("Phone number changed successfully for user ID: {} to {}", userId, newPhone);
            verificationService.invalidateCode(newPhone, code); // 使验证码失效

            // 更新session中的用户信息
            User userInSession = (User) session.getAttribute("user");
            if (userInSession != null && userInSession.getId().equals(userId)) {
                userInSession.setTelphone(newPhone);
                session.setAttribute("user", userInSession);
            }
            return true;
        } else {
            logger.error("Failed to change phone number for user ID: {}", userId);
            session.setAttribute("msg", "手机号修改失败");
            return false;
        }
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

        // 检查新邮箱是否与旧邮箱相同
        User currentUser = userMapper.getUserById(userId);
        if (currentUser != null && newEmail.equalsIgnoreCase(currentUser.getEmail())) { // 邮箱比较忽略大小写
            session.setAttribute("msg", "新邮箱与当前邮箱相同，无需更改");
            verificationService.invalidateCode(newEmail, code);
            return true;
        }


        // 更新邮箱
        int result = userMapper.updateEmail(userId, newEmail);

        if (result > 0) {
            logger.info("Email changed successfully for user ID: {} to {}", userId, newEmail);
            verificationService.invalidateCode(newEmail, code); // 使验证码失效

            // 更新session中的用户信息
            User userInSession = (User) session.getAttribute("user");
            if (userInSession != null && userInSession.getId().equals(userId)) {
                userInSession.setEmail(newEmail);
                session.setAttribute("user", userInSession);
            }
            return true;
        } else {
            logger.error("Failed to change email for user ID: {}", userId);
            session.setAttribute("msg", "邮箱修改失败");
            return false;
        }
    }

    @Override
    public boolean freezeUser(Integer userId) {
        User user = userMapper.getUserById(userId);
        if (user != null && !USER_STATUS_UPGRADED.equals(user.getStatus()) && !USER_STATUS_DELETED.equals(user.getStatus()) && !USER_STATUS_FROZEN.equals(user.getStatus())) {
            user.setStatus(USER_STATUS_FROZEN);
            int result = userMapper.updateUserStatus(user);
            logger.info("User {} status updated to F (Frozen). Result: {}", userId, result);
            return result > 0;
        }
        if (user != null && USER_STATUS_FROZEN.equals(user.getStatus())) {
            logger.info("User {} is already frozen.", userId);
            return true; // 已经是目标状态，视为成功
        }
        logger.warn("Attempted to freeze non-existent, upgraded, deleted, or already frozen user with ID: {}", userId);
        return false;
    }

    @Override
    public boolean unfreezeUser(Integer userId) {
        User user = userMapper.getUserById(userId);
        // 只有冻结状态的用户可以解冻
        if (user != null && USER_STATUS_FROZEN.equals(user.getStatus())) {
            user.setStatus(USER_STATUS_ACTIVE);
            int result = userMapper.updateUserStatus(user);
            logger.info("User {} status updated to Y (Active/Unfrozen). Result: {}", userId, result);
            return result > 0;
        }
        if (user != null && USER_STATUS_ACTIVE.equals(user.getStatus()) && !USER_STATUS_FROZEN.equals(user.getStatus())) { // 如果不是F，但已经是Y
            logger.info("User {} is already active (not frozen).", userId);
            return true;
        }
        logger.warn("Attempted to unfreeze user with ID: {} who is not frozen or does not exist.", userId);
        return false;
    }

    @Override
    public boolean addToBlacklist(Integer userId) {
        User user = userMapper.getUserById(userId);
        if (user != null && !USER_STATUS_UPGRADED.equals(user.getStatus()) && !USER_STATUS_DELETED.equals(user.getStatus()) && !USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            user.setStatus(USER_STATUS_BLACKLISTED);
            int result = userMapper.updateUserStatus(user);
            logger.info("User {} status updated to B (Blacklisted). Result: {}", userId, result);
            return result > 0;
        }
        if (user != null && USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            logger.info("User {} is already blacklisted.", userId);
            return true;
        }
        logger.warn("Attempted to blacklist non-existent, upgraded, deleted, or already blacklisted user with ID: {}", userId);
        return false;
    }

    @Override
    public boolean removeFromBlacklist(Integer userId) {
        User user = userMapper.getUserById(userId);
        // 只有黑名单用户可以移除黑名单
        if (user != null && USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            user.setStatus(USER_STATUS_ACTIVE);
            int result = userMapper.updateUserStatus(user);
            logger.info("User {} status updated to Y (Removed from blacklist). Result: {}", userId, result);
            return result > 0;
        }
        if (user != null && USER_STATUS_ACTIVE.equals(user.getStatus()) && !USER_STATUS_BLACKLISTED.equals(user.getStatus())) {
            logger.info("User {} is already active (not blacklisted).", userId);
            return true;
        }
        logger.warn("Attempted to remove user from blacklist with ID: {} who is not blacklisted or does not exist.", userId);
        return false;
    }

    @Override
    public boolean deleteUser(Integer userId) {
        User user = userMapper.getUserById(userId);
        // 不能删除已升级为管理员的用户记录（除非先降级）
        // 不能重复删除已经是 'D' 状态的用户
        if (user != null && !USER_STATUS_UPGRADED.equals(user.getStatus()) && !USER_STATUS_DELETED.equals(user.getStatus())) {
            user.setStatus(USER_STATUS_DELETED);
            int result = userMapper.updateUserStatus(user);
            logger.info("User {} status updated to D (Logically Deleted). Result: {}", userId, result);
            return result > 0;
        }
        if (user != null && USER_STATUS_DELETED.equals(user.getStatus())) {
            logger.info("User {} is already deleted.", userId);
            return true;
        }
        logger.warn("Attempted to delete non-existent, upgraded, or already deleted user with ID: {}", userId);
        return false;
    }

    @Override
    @Transactional
    public boolean upgradeUserToAdmin(Integer userId) {
        User userToUpgrade = userMapper.getUserById(userId);

        if (userToUpgrade == null) {
            logger.warn("Upgrade failed: User with ID {} not found.", userId);
            return false;
        }

        // 检查用户状态，例如不能升级已删除或已升级的用户
        if (USER_STATUS_DELETED.equals(userToUpgrade.getStatus())) {
            logger.warn("Upgrade failed: User with ID {} is deleted. Status: {}", userId, userToUpgrade.getStatus());
            return false;
        }
        if (USER_STATUS_UPGRADED.equals(userToUpgrade.getStatus())) {
            logger.info("Upgrade info: User with ID {} is already marked as upgraded. Checking admin table consistency.", userId);
            // 已经是M状态，检查管理员表是否真的有此管理员
            Admin existingAdmin = adminMapper.getAdminByAccount(userToUpgrade.getAccount());
            if (existingAdmin != null) {
                logger.info("Admin account {} already exists for user ID {}. No action needed.", userToUpgrade.getAccount(), userId);
                return true; // 已经符合目标状态
            } else {
                logger.warn("Data inconsistency: User {} is 'M' but no admin record for account {}. Proceeding to create admin.", userId, userToUpgrade.getAccount());
                // 状态是M但管理员记录丢失，继续尝试创建
            }
        }


        // 检查管理员表中是否已存在同名账号
        Admin existingAdmin = adminMapper.getAdminByAccount(userToUpgrade.getAccount());
        if (existingAdmin != null) {
            logger.warn("Upgrade failed: An admin with account '{}' already exists. User ID: {}", userToUpgrade.getAccount(), userId);
            // 如果管理员已存在，但原用户记录状态不是UPGRADED，则更新用户状态
            if (!USER_STATUS_UPGRADED.equals(userToUpgrade.getStatus())) {
                userToUpgrade.setStatus(USER_STATUS_UPGRADED);
                userMapper.updateUserStatus(userToUpgrade);
                logger.info("User {} (Account: {}) marked as upgraded because admin account already exists.", userId, userToUpgrade.getAccount());
            }
            return true; // 目标是成为管理员，而管理员已存在，可视为成功
        }

        // 创建新的 Admin 对象
        Admin newAdmin = new Admin();
        newAdmin.setAccount(userToUpgrade.getAccount());
        newAdmin.setPassword(userToUpgrade.getPassword()); // 直接使用用户加密后的密码
        // 管理员状态，根据你的 wn_manager 表设计。如果它有 status 字段，这里设置。
        // 假设1为激活状态，如果你的表没有status字段，可以移除下面这行。
        newAdmin.setStatus(1); // 假设 1 代表管理员激活状态

        int adminInsertResult = adminMapper.insertAdmin(newAdmin);
        if (adminInsertResult > 0) {
            logger.info("Admin record created for account: {}", newAdmin.getAccount());
            // 管理员插入成功后，更新原用户表中的状态
            userToUpgrade.setStatus(USER_STATUS_UPGRADED);
            int userUpdateResult = userMapper.updateUserStatus(userToUpgrade);
            if (userUpdateResult > 0) {
                logger.info("User with ID {} successfully upgraded to admin. Account: {}", userId, newAdmin.getAccount());
                return true;
            } else {
                logger.error("Failed to update user status for ID {} after upgrading to admin. Transaction will roll back.", userId);
                // 由于有 @Transactional, 如果这里抛异常或返回false（导致调用方认为失败），整个事务会回滚
                throw new RuntimeException("Failed to update user status after admin creation for userId: " + userId + ". Admin insert rolled back.");
            }
        } else {
            logger.error("Failed to insert new admin record for user ID {}. Account: {}", userId, userToUpgrade.getAccount());
            return false;
        }
    }

    @Override
    public User getUserById(Integer userId) {
        if (userId == null) {
            logger.warn("Attempted to get user with null ID.");
            return null;
        }
        User user = userMapper.getUserById(userId);
        if (user == null) {
            logger.info("No user found with ID: {}", userId);
        }
        return user;
    }

    @Override
    @Transactional
    public boolean demoteAdminToUser(Integer userId) {
        User userToDemote = userMapper.getUserById(userId);

        if (userToDemote == null) {
            logger.warn("Demotion failed: User record with ID {} not found.", userId);
            return false;
        }

        Admin adminRecord = adminMapper.getAdminByAccount(userToDemote.getAccount());

        // 检查该用户是否确实是已升级的管理员 (status == 'M')
        // 并且管理员表中也应该有记录
        if (!USER_STATUS_UPGRADED.equals(userToDemote.getStatus())) {
            logger.warn("Demotion check: User with ID {} (Account: {}) is not marked as an upgraded admin (Status: {}).",
                    userId, userToDemote.getAccount(), userToDemote.getStatus());
            if (adminRecord == null) {
                logger.info("User {} is not 'M' and no admin record for account {}. No demotion needed.", userId, userToDemote.getAccount());
                return true; // 已经不是管理员状态，也无管理员记录，视为成功
            } else {
                logger.warn("Data inconsistency: User {} status is '{}' but admin record for account {} exists. Proceeding with demotion.",
                        userId, userToDemote.getStatus(), userToDemote.getAccount());
                // 用户状态不对，但管理员记录存在，则继续执行删除管理员记录并将用户状态置为Y
            }
        } else { // 用户状态是 'M'
            if (adminRecord == null) {
                logger.warn("Data inconsistency: User {} is 'M' but admin record for account '{}' not found. Restoring user status to Active.",
                        userId, userToDemote.getAccount());
                // 管理员记录丢失，但用户状态是M，则恢复用户状态
                userToDemote.setStatus(USER_STATUS_ACTIVE);
                userMapper.updateUserStatus(userToDemote);
                return true; // 视为部分成功或数据修正
            }
        }

        // 如果 adminRecord 在上面逻辑中已经判断为 null 且返回了，这里就不会执行
        // 执行到这里，说明 adminRecord 存在 (或者用户状态不是M但adminRecord存在)
        if (adminRecord == null) { // 再次检查，理论上不应为null如果上面逻辑没提前返回
            logger.error("Unexpected state: Admin record for account {} is null before deletion attempt. User ID: {}", userToDemote.getAccount(), userId);
            // 即使管理员记录不存在，也尝试将用户状态恢复为正常（如果状态是M）
            if (USER_STATUS_UPGRADED.equals(userToDemote.getStatus())) {
                userToDemote.setStatus(USER_STATUS_ACTIVE);
                userMapper.updateUserStatus(userToDemote);
                logger.info("User {} status restored to Active as admin record was missing (double check).", userId);
            }
            return true; // 认为操作部分成功或已处于期望状态
        }


        // 从 wn_manager 表删除管理员记录
        int adminDeleteResult = adminMapper.deleteAdminByAccount(userToDemote.getAccount());
        if (adminDeleteResult > 0) {
            logger.info("Admin record deleted for account: {}", userToDemote.getAccount());
            // 管理员删除成功后，更新原用户表中的状态为 'Y' (Active)
            userToDemote.setStatus(USER_STATUS_ACTIVE);
            int userUpdateResult = userMapper.updateUserStatus(userToDemote);
            if (userUpdateResult > 0) {
                logger.info("Admin account '{}' (from User ID: {}) successfully demoted to regular user.", userToDemote.getAccount(), userId);
                return true;
            } else {
                logger.error("Failed to update user status for ID {} after demoting admin. Transaction will roll back.", userId);
                throw new RuntimeException("Failed to update user status after admin demotion for userId: " + userId + ". Admin delete rolled back.");
            }
        } else {
            // 这种情况理论上不应该发生，如果上面的 adminRecord 查询到了数据并且存在
            logger.error("Failed to delete admin record for account '{}' (from User ID {}), though it was expected to exist. Check for concurrent modifications or DB issues.",
                    userToDemote.getAccount(), userId);
            // 即使删除失败，如果用户状态是M，也尝试修正
            if (USER_STATUS_UPGRADED.equals(userToDemote.getStatus())) {
                logger.warn("Attempting to restore user {} status to Active despite admin delete failure.", userId);
                userToDemote.setStatus(USER_STATUS_ACTIVE);
                userMapper.updateUserStatus(userToDemote); // 这可能不会成功，因为事务可能已标记回滚
            }
            return false;
        }
    }
}
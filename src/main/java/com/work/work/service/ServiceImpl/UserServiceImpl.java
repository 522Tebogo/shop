package com.work.work.service.ServiceImpl;

import com.work.work.entity.User;
import com.work.work.mapper.UserMapper;
import com.work.work.service.UserService;
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
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserMapper userMapper;

    public User login(String account, String password, HttpSession session){
        User user = userMapper.getUserByAccount(account);
        if(user == null){
            System.out.println("用户不存在，请先注册！");
            return null;
        }
        else{
            String pass = DigestUtils.md5DigestAsHex(password.getBytes());
            System.out.println("输入密码MD5: " + pass);
            System.out.println("数据库密码: " + user.getPassword());
            if(user.getPassword().equals(pass)){
                System.out.println("密码正确");
                return user;
            }
            else{
                session.setAttribute("msg","账号或密码不正确");
                return null;
            }
        }
    }

    public boolean insertUser(String account, String password, String telphone, String email, MultipartFile avatar) throws IOException {
        User curUser = userMapper.getUserByAccount(account);
        if(curUser!=null){
            return false;
        }
        String avatarPath = "";
        if (avatar != null && !avatar.isEmpty() && avatar.getSize() > 0) {
            avatarPath = this.saveAvatar(avatar);
        } else {
            // 设置默认头像路径
            avatarPath = "/static/images/default-avatar.png";
        }
        
        User newUser = new User();
        newUser.setAccount(account);

        newUser.setPassword(DigestUtils.md5DigestAsHex(password.getBytes()));
        newUser.setTelphone(telphone);
        newUser.setEmail(email);

        newUser.setPoints(0);
        newUser.setMoney(BigDecimal.valueOf(0.0));
        newUser.setRegTime(LocalDateTime.now());
        newUser.setStatus("Y");
        newUser.setAvatar(avatarPath);
        return userMapper.insert(newUser)>0 ;
    }

    @Override
    public String saveAvatar(MultipartFile file) throws IOException {
        // 创建上传目录
        String uploadDir = "src/main/webapp/static/images/avatars";
        Path uploadPath = Paths.get(uploadDir);
        
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // 生成唯一文件名
        String uniqueFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path filePath = uploadPath.resolve(uniqueFileName);
        
        // 保存文件
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        // 返回相对路径
        return "/static/images/avatars/" + uniqueFileName;
    }
}

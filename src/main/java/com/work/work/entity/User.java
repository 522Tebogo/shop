package com.work.work.entity;

import lombok.Data;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class User {
    @Getter
    private Integer id;
    private String account;
    private String password;
    private String email;
    private String telphone;
    private Integer points;
    private BigDecimal money;
    private String avatar;
    private LocalDateTime regTime;
    private String status;
    private Date lastLoginTime;
    private String lastLoginIp;
    private String nickname;


}

package com.work.work.entity;

import lombok.Data;

import java.time.LocalDateTime;


@Data
public class VerificationCode {
    private Integer id;
    private String target; //
    private String code; //
    private LocalDateTime createTime; //
    private LocalDateTime expireTime; //
    private Integer status; //
    
    public VerificationCode() {
    }
    
    public VerificationCode(String target, String code, LocalDateTime createTime, LocalDateTime expireTime) {
        this.target = target;
        this.code = code;
        this.createTime = createTime;
        this.expireTime = expireTime;
        this.status = 0;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(LocalDateTime expireTime) {
        this.expireTime = expireTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
} 
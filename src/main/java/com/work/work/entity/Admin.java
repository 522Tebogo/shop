package com.work.work.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Admin {
    private int id;
    private String account;
    private String password;
    private String last_login_time;
    private String last_login_ip;
    private Integer status;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getLast_login_time() {
        return last_login_time;
    }

    public void setLast_login_time(String last_login_time) {
        this.last_login_time = last_login_time;
    }

    public String getLast_login_ip() {
        return last_login_ip;
    }

    public void setLast_login_ip(String last_login_ip) {
        this.last_login_ip = last_login_ip;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}

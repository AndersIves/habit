package com.cqu.zhang.habit.entity.mysql;


import javax.persistence.*;

@Entity(name = "user")
public class User {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long uid;
  private Long infoId;
  private String email;
  private String pwd;

  @Override
  public String toString() {
    return "User{" +
            "uid=" + uid +
            ", infoId=" + infoId +
            ", email='" + email + '\'' +
            ", pwd='" + pwd + '\'' +
            '}';
  }

  public Long getUid() {
    return uid;
  }

  public void setUid(Long uid) {
    this.uid = uid;
  }


  public Long getInfoId() {
    return infoId;
  }

  public void setInfoId(Long infoId) {
    this.infoId = infoId;
  }


  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }


  public String getPwd() {
    return pwd;
  }

  public void setPwd(String pwd) {
    this.pwd = pwd;
  }

}

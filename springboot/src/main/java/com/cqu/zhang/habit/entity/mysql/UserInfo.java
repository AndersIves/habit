package com.cqu.zhang.habit.entity.mysql;


import javax.persistence.*;

@Entity(name = "user_info")
public class UserInfo {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long infoId;
  private Long photoId;
  private Long coinId;
  private String userName;
  private String gender;
  private String birthday;

  @Override
  public String toString() {
    return "UserInfo{" +
            "infoId=" + infoId +
            ", photoId=" + photoId +
            ", coinId=" + coinId +
            ", userName='" + userName + '\'' +
            ", gender='" + gender + '\'' +
            ", birthday='" + birthday + '\'' +
            '}';
  }

  public Long getInfoId() {
    return infoId;
  }

  public void setInfoId(Long infoId) {
    this.infoId = infoId;
  }


  public Long getPhotoId() {
    return photoId;
  }

  public void setPhotoId(Long photoId) {
    this.photoId = photoId;
  }


  public Long getCoinId() {
    return coinId;
  }

  public void setCoinId(Long coinId) {
    this.coinId = coinId;
  }


  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }


  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }


  public String getBirthday() {
    return birthday;
  }

  public void setBirthday(String birthday) {
    this.birthday = birthday;
  }

}

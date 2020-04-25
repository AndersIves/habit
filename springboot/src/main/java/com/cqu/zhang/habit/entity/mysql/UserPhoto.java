package com.cqu.zhang.habit.entity.mysql;


import javax.persistence.*;
import java.util.Arrays;

@Entity(name = "user_photo")
public class UserPhoto {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long photoId;
  private byte[] photo;

  @Override
  public String toString() {
    return "UserPhoto{" +
            "photoId=" + photoId +
            ", photo=" + Arrays.toString(photo) +
            '}';
  }

  public Long getPhotoId() {
    return photoId;
  }

  public void setPhotoId(Long photoId) {
    this.photoId = photoId;
  }


  public byte[] getPhoto() {
    return photo;
  }

  public void setPhoto(byte[] photo) {
    this.photo = photo;
  }

}

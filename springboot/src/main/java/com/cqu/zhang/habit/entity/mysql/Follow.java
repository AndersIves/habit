package com.cqu.zhang.habit.entity.mysql;

import javax.persistence.*;

@Entity(name = "follow")
public class Follow {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  private Long uid;
  private Long followUid;

  @Override
  public String toString() {
    return "Follow{" +
            "id=" + id +
            ", uid=" + uid +
            ", followUid=" + followUid +
            '}';
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }


  public Long getUid() {
    return uid;
  }

  public void setUid(Long uid) {
    this.uid = uid;
  }


  public Long getFollowUid() {
    return followUid;
  }

  public void setFollowUid(Long followUid) {
    this.followUid = followUid;
  }

}

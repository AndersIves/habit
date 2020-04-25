package com.cqu.zhang.habit.entity.mysql;


import javax.persistence.*;

@Entity(name = "purchased")
public class Purchased {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  private Long uid;
  private Long goodsId;

  @Override
  public String toString() {
    return "Purchased{" +
            "id=" + id +
            ", uid=" + uid +
            ", goodsId=" + goodsId +
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


  public Long getGoodsId() {
    return goodsId;
  }

  public void setGoodsId(Long goodsId) {
    this.goodsId = goodsId;
  }

}

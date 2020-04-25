package com.cqu.zhang.habit.entity.mysql;


import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.*;

@Entity(name = "coin")
public class Coin {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long coinId;
  private Long coins;

  @Override
  public String toString() {
    return "Coin{" +
            "coinId=" + coinId +
            ", coins=" + coins +
            '}';
  }

  public Long getCoinId() {
    return coinId;
  }

  public void setCoinId(Long coinId) {
    this.coinId = coinId;
  }


  public Long getCoins() {
    return coins;
  }

  public void setCoins(Long coins) {
    this.coins = coins;
  }

}

package com.cqu.zhang.habit.entity.mysql;


import javax.persistence.*;

@Entity(name = "goods")
public class Goods {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long goodsId;
    private String name;
    private Long price;
    private Long count;
    private String description;
    private String goodsToken;


    @Override
    public String toString() {
        return "Goods{" +
                "goodsId=" + goodsId +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", count=" + count +
                ", description='" + description + '\'' +
                ", goodsToken='" + goodsToken + '\'' +
                '}';
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }

    public Long getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(Long goodsId) {
        this.goodsId = goodsId;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getGoodsToken() {
        return goodsToken;
    }

    public void setGoodsToken(String goodsToken) {
        this.goodsToken = goodsToken;
    }

}

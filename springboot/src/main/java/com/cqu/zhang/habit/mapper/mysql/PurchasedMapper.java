package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.Purchased;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PurchasedMapper extends JpaRepository<Purchased, Long> {
    Purchased findFirstByGoodsId(Long goodsId);
}

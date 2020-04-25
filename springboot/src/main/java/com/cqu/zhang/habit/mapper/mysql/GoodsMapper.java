package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.Goods;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoodsMapper extends JpaRepository<Goods, Long> {
}

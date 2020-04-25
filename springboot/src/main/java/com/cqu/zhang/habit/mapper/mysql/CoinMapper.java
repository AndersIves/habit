package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.Coin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CoinMapper extends JpaRepository<Coin, Long> {
    @Query(value = "SELECT coin.* FROM coin INNER JOIN user_info INNER JOIN `user`\n" +
            "ON coin.coin_id = user_info.coin_id AND `user`.info_id = user_info.info_id\n" +
            "WHERE `user`.uid = :uid LIMIT 1", nativeQuery = true)
    Coin findCoinByUid(Long uid);
    @Query(value = "SELECT `user`.uid FROM coin INNER JOIN user_info INNER JOIN `user`\n" +
            "ON coin.coin_id = user_info.coin_id AND `user`.info_id = user_info.info_id\n" +
            "ORDER BY coin.coins DESC \n" +
            "LIMIT :limitCount", nativeQuery = true)
    List<Long> findUidSortByCoinsLimit(Long limitCount);
}

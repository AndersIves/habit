package com.cqu.zhang.habit.mapper.mysql;

import com.cqu.zhang.habit.entity.mysql.Follow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FollowMapper extends JpaRepository<Follow, Long> {
    @Query(value = "SELECT follow.follow_uid FROM follow INNER JOIN `user` INNER JOIN user_info INNER JOIN coin\n" +
            "ON coin.coin_id = user_info.coin_id AND user_info.info_id = `user`.info_id AND follow.follow_uid = `user`.info_id \n" +
            "WHERE follow.uid = :uid ORDER BY coin.coins DESC;", nativeQuery = true)
    List<Long> findFollowUidByUidSortByCoin(Long uid);
    Follow findFollowByUidAndFollowUid(Long uid, Long followUid);
}

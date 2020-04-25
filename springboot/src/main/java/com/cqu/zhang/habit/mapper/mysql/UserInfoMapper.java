package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.UserInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserInfoMapper extends JpaRepository<UserInfo, Long> {
    @Query(value = "SELECT user_info.* FROM user_info INNER JOIN `user`\n" +
            "ON `user`.info_id = user_info.info_id\n" +
            "WHERE `user`.uid = :uid LIMIT 1", nativeQuery = true)
    UserInfo findUserInfoByUid(Long uid);
    @Query(value = "SELECT `user`.uid FROM user_info INNER JOIN `user`\n" +
            "ON `user`.info_id = user_info.info_id\n" +
            "WHERE user_info.user_name like :userName", nativeQuery = true)
    List<Long> findUidByUserNameLike(String userName);
}

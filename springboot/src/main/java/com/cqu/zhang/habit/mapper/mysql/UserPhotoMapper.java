package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.Coin;
import com.cqu.zhang.habit.entity.mysql.UserPhoto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface UserPhotoMapper extends JpaRepository<UserPhoto, Long> {
    @Query(value = "SELECT user_photo.* FROM user_photo INNER JOIN user_info INNER JOIN `user`\n" +
            "ON user_photo.photo_id = user_info.photo_id AND `user`.info_id = user_info.info_id \n" +
            "WHERE `user`.uid = :uid LIMIT 1", nativeQuery = true)
    UserPhoto findUserPhotoByUid(Long uid);
}

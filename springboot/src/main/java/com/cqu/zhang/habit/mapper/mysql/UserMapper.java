package com.cqu.zhang.habit.mapper.mysql;


import com.cqu.zhang.habit.entity.mysql.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserMapper extends JpaRepository<User, Long> {
    User findFirstByEmail(String email);
}

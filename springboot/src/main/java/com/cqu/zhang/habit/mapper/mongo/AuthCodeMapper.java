package com.cqu.zhang.habit.mapper.mongo;

import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.Token;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthCodeMapper extends MongoRepository<AuthCode, String> {
    void deleteByEmail(String email);
    AuthCode findFirstByEmail(String email);
}

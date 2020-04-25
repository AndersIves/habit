package com.cqu.zhang.habit.mapper.mongo;

import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.MongoBaseEntity;
import com.cqu.zhang.habit.entity.mongo.Token;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface TokenMapper extends MongoRepository<Token, String> {
    Token findFirstByUid(Long uid);
    void deleteByUid(Long uid);
}

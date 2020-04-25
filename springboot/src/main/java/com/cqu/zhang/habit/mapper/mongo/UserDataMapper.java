package com.cqu.zhang.habit.mapper.mongo;

import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.MongoBaseEntity;
import com.cqu.zhang.habit.entity.mongo.UserData;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.Date;

@Repository
public interface UserDataMapper extends MongoRepository<UserData, String> {
    UserData findFirstByUid(Long uid);
}

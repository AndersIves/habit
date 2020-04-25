package com.cqu.zhang.habit.mapper.mongo;

import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.IncreaseCoinTimes;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IncreaseCoinTimesMapper extends MongoRepository<IncreaseCoinTimes, String> {
    IncreaseCoinTimes findFirstByUid(Long uid);
}

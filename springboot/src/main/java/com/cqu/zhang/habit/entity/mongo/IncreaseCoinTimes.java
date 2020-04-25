package com.cqu.zhang.habit.entity.mongo;

import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "increase_coin_times")
public class IncreaseCoinTimes extends MongoBaseEntity {
    private Long uid;
    private Long times;
    @Indexed(expireAfterSeconds = 60 * 60 * 12)
    private Date createDate = new Date();

    @Override
    public String toString() {
        return "IncreaseCoinTimes{" +
                "uid=" + uid +
                ", times=" + times +
                ", createDate=" + createDate +
                ", id='" + id + '\'' +
                '}';
    }

    public Long getUid() {
        return uid;
    }

    public void setUid(Long uid) {
        this.uid = uid;
    }

    public Long getTimes() {
        return times;
    }

    public void setTimes(Long times) {
        this.times = times;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}

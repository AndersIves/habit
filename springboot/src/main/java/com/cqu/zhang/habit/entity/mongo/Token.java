package com.cqu.zhang.habit.entity.mongo;

import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "token")
public class Token extends MongoBaseEntity {

    private Long uid;
    private String token;
    @Indexed(expireAfterSeconds = 60 * 60 * 24 * 30)
    private Date createDate = new Date();

    @Override
    public String toString() {
        return "Token{" +
                "uid=" + uid +
                ", token='" + token + '\'' +
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}

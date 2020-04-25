package com.cqu.zhang.habit.entity.mongo;

import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Arrays;
import java.util.Date;

@Document(collection = "user_data")
public class UserData extends MongoBaseEntity {
    private Long uid;
    private byte[] data;
    private Date createDate = new Date();

    @Override
    public String toString() {
        return "UserData{" +
                "uid=" + uid +
                ", data=" + Arrays.toString(data) +
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

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}

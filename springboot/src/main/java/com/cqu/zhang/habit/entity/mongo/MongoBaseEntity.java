package com.cqu.zhang.habit.entity.mongo;

import org.springframework.data.annotation.Id;

public class MongoBaseEntity {
    @Id
    protected String id;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}

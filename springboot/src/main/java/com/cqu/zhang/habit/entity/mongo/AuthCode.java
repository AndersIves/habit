package com.cqu.zhang.habit.entity.mongo;

import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "auth_code")
public class AuthCode extends MongoBaseEntity {
    private String email;
    private String authCode;
    private String purpose;
    @Indexed(expireAfterSeconds = 60 * 5)
    private Date createDate = new Date();

    @Override
    public String toString() {
        return "AuthCode{" +
                "email='" + email + '\'' +
                ", authCode='" + authCode + '\'' +
                ", purpose='" + purpose + '\'' +
                ", createDate=" + createDate +
                '}';
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAuthCode() {
        return authCode;
    }

    public void setAuthCode(String authCode) {
        this.authCode = authCode;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}

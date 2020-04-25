package com.cqu.zhang.habit.common;

import org.springframework.http.ResponseEntity;

public class MyResponse {
    public static final String OK = "OK";
    public static final String RES_REPEATED = "RES_REPEATED";
    public static final String RES_NOT_MATCH = "RES_NOT_MATCH";
    public static final String INVALID_AUTHORIZE = "INVALID_AUTHORIZE";
    public static final String RES_NOT_FOUND = "RES_NOT_FOUND";
    public static final String CREATE_FAIL = "CREATE_FAIL";
    public static final String RES_NOT_ALLOW = "RES_NOT_ALLOW";

    public static ResponseEntity.BodyBuilder responseCode(String responseCode) {
        return ResponseEntity.ok().header("responseCode", responseCode);
    }

    public static ResponseEntity.BodyBuilder badRequest() {
        return ResponseEntity.badRequest();
    }
}

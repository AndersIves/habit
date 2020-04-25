package com.cqu.zhang.habit.controller;

import com.cqu.zhang.habit.common.MyResponse;
import com.cqu.zhang.habit.entity.mongo.UserData;
import com.cqu.zhang.habit.entity.mysql.User;
import com.cqu.zhang.habit.entity.mysql.UserInfo;
import com.cqu.zhang.habit.entity.mysql.UserPhoto;
import com.cqu.zhang.habit.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {
    final
    UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    ResponseEntity<List<Long>> getUserInfoLikeUserName(@RequestParam String name) {
        return userService.getUserInfoLikeUserName(name);
    }

    @PostMapping("/")
    ResponseEntity<Void> signUp(@RequestHeader String authCode, @RequestBody User user) {
        return userService.signUp(authCode, user);
    }

    @PutMapping("/")
    ResponseEntity<Void> resetPwd(@RequestHeader String authCode, @RequestBody User user) {
        return userService.resetPwd(authCode, user);
    }

//    @GetMapping("/{uid}")
//    ResponseEntity<User> getUser(@PathVariable String uid) {
//        return userService.getUser(uid);
//    }

    @GetMapping("/{uid}/userInfo")
    ResponseEntity<UserInfo> getUserInfo(@PathVariable String uid) {
        return userService.getUserInfo(uid);
    }

    @PutMapping("/{uid}/userInfo")
    ResponseEntity<Void> modifyUserInfo(@RequestHeader String token, @RequestBody UserInfo userInfo, @PathVariable String uid) {
        return userService.modifyUserInfo(uid, token, userInfo);
    }

    @GetMapping("/{uid}/userPhoto")
    ResponseEntity<byte[]> getUserPhoto(@PathVariable String uid) {
        return userService.getUserPhoto(uid);
    }

    @PutMapping("/{uid}/userPhoto")
    ResponseEntity<Void> modifyUserPhoto(@PathVariable String uid, @RequestHeader String token, @RequestBody UserPhoto userPhoto) {
        return userService.modifyUserPhoto(uid, token, userPhoto);
    }

    @GetMapping("/{uid}/coin")
    ResponseEntity<Long> getCoin(@PathVariable String uid) {
        return userService.getCoin(uid);
    }

    @PutMapping("/{uid}/coin")
    ResponseEntity<Long> increaseCoin(@PathVariable String uid, @RequestHeader String token) {
        return userService.increaseCoin(uid, token);
    }

    @PutMapping("/{uid}/data")
    ResponseEntity<Void> uploadData(@PathVariable String uid, @RequestHeader String token, @RequestBody UserData userData) {
        return userService.uploadData(uid, token, userData);
    }

    @GetMapping("/{uid}/data")
    ResponseEntity<byte[]> downloadData(@PathVariable String uid, @RequestHeader String token) {
        return userService.downloadData(uid, token);
    }
}

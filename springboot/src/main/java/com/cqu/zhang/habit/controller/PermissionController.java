package com.cqu.zhang.habit.controller;

import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.Token;
import com.cqu.zhang.habit.entity.mysql.User;
import com.cqu.zhang.habit.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/permission")
public class PermissionController {
    final
    PermissionService permissionService;

    public PermissionController(PermissionService permissionService) {
        this.permissionService = permissionService;
    }

    @PostMapping("/token")
    ResponseEntity<Token> signIn(@RequestBody User user) {
        return permissionService.signIn(user);
    }

    @GetMapping("/token")
    ResponseEntity<Boolean> getTokenState(@RequestParam Long uid, @RequestParam String token) {
        return permissionService.getTokenState(uid, token);
    }

    @PostMapping("/authCode")
    ResponseEntity<Void> createAuthCode(@RequestBody AuthCode authCode) {
        return permissionService.createAuthCode(authCode);
    }
}

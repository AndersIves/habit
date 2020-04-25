package com.cqu.zhang.habit.controller;

import com.cqu.zhang.habit.entity.mysql.Follow;
import com.cqu.zhang.habit.service.CommunityService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/community")
public class CommunityController {
    final
    CommunityService communityService;

    public CommunityController(CommunityService communityService) {
        this.communityService = communityService;
    }

    @PostMapping("/follow")
    ResponseEntity<String> follow(@RequestHeader String token, @RequestBody Follow follow) {
       return communityService.follow(token, follow);
    }

    @GetMapping("/follow")
    ResponseEntity<List<Long>> getFollowList(@RequestHeader String token, @RequestParam String uid) {
        return communityService.getFollowList(token, uid);
    }

    @GetMapping("/{uid}/follow/{followUid}")
    ResponseEntity<Boolean> getFollowState(@RequestHeader String token, @PathVariable String uid, @PathVariable String followUid) {
        return communityService.getFollowState(token, uid, followUid);
    }


    @GetMapping("/coinTop")
    ResponseEntity<List<Long>> getCoinTop(@RequestParam String topCount) {
        return communityService.getCoinTop(topCount);
    }
}

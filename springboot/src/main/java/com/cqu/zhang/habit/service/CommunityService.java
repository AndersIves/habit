package com.cqu.zhang.habit.service;

import com.cqu.zhang.habit.common.MyResponse;
import com.cqu.zhang.habit.entity.mysql.Follow;
import com.cqu.zhang.habit.mapper.mysql.CoinMapper;
import com.cqu.zhang.habit.mapper.mysql.FollowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommunityService {
    final
    PermissionService permissionService;
    final
    FollowMapper followMapper;
    final
    CoinMapper coinMapper;

    public CommunityService(PermissionService permissionService, FollowMapper followMapper, CoinMapper coinMapper) {
        this.permissionService = permissionService;
        this.followMapper = followMapper;
        this.coinMapper = coinMapper;
    }

    public ResponseEntity<List<Long>> getFollowList(String token, String uid) {
        long uidLong = Long.parseLong(uid);
        // token 效验
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 查表返回
        List<Long> byUid = followMapper.findFollowUidByUidSortByCoin(uidLong);
        return MyResponse.responseCode(MyResponse.OK).body(byUid);
    }

    // 关注用户
    public ResponseEntity<String> follow(String token, Follow follow) {
        // 传参效验
        if (follow.getUid() == null || follow.getFollowUid() == null) {
            return MyResponse.badRequest().build();
        }
        // 自己关注自己
        if (follow.getUid().equals(follow.getFollowUid())) {
            return MyResponse.responseCode(MyResponse.RES_NOT_ALLOW).build();
        }
        // token 效验
        if (!permissionService.verifyToken(follow.getUid(), token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 是否已关注
        Follow localFollow = followMapper.findFollowByUidAndFollowUid(follow.getUid(), follow.getFollowUid());
        if (localFollow != null) {
            // 已关注
            followMapper.deleteById(localFollow.getId());
            return MyResponse.responseCode(MyResponse.OK).body("unFollowed");
        } else {
            // 未关注
            follow.setId(null);
            followMapper.save(follow);
            return MyResponse.responseCode(MyResponse.OK).body("followed");
        }
    }

    public ResponseEntity<Boolean> getFollowState(String token, String uid, String followUid) {
        long uidLong = Long.parseLong(uid);
        long followUidLong = Long.parseLong(followUid);
        // token 效验
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        Follow localFollow = followMapper.findFollowByUidAndFollowUid(uidLong, followUidLong);
        if (localFollow == null) {
            return MyResponse.responseCode(MyResponse.OK).body(false);
        }
        return MyResponse.responseCode(MyResponse.OK).body(true);
    }


    public ResponseEntity<List<Long>> getCoinTop(String topCount) {
        List<Long> topByCoinsLimit = coinMapper.findUidSortByCoinsLimit(Long.parseLong(topCount));
        return MyResponse.responseCode(MyResponse.OK).body(topByCoinsLimit);
    }
}

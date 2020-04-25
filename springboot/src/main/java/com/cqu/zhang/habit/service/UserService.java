package com.cqu.zhang.habit.service;

import com.cqu.zhang.habit.common.MyCopyUtils;
import com.cqu.zhang.habit.common.MyResponse;
import com.cqu.zhang.habit.common.ValueBuilder;
import com.cqu.zhang.habit.entity.mongo.IncreaseCoinTimes;
import com.cqu.zhang.habit.entity.mongo.UserData;
import com.cqu.zhang.habit.entity.mysql.Coin;
import com.cqu.zhang.habit.entity.mysql.User;
import com.cqu.zhang.habit.entity.mysql.UserInfo;
import com.cqu.zhang.habit.entity.mysql.UserPhoto;
import com.cqu.zhang.habit.mapper.mongo.IncreaseCoinTimesMapper;
import com.cqu.zhang.habit.mapper.mongo.UserDataMapper;
import com.cqu.zhang.habit.mapper.mysql.CoinMapper;
import com.cqu.zhang.habit.mapper.mysql.UserInfoMapper;
import com.cqu.zhang.habit.mapper.mysql.UserMapper;
import com.cqu.zhang.habit.mapper.mysql.UserPhotoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class UserService {
    final
    PermissionService permissionService;
    final
    UserMapper userMapper;
    final
    UserInfoMapper userInfoMapper;
    final
    UserPhotoMapper userPhotoMapper;
    final
    CoinMapper coinMapper;
    final
    IncreaseCoinTimesMapper increaseCoinTimesMapper;
    final
    UserDataMapper userDataMapper;

    public UserService(PermissionService permissionService, UserMapper userMapper, UserInfoMapper userInfoMapper, UserPhotoMapper userPhotoMapper, CoinMapper coinMapper, IncreaseCoinTimesMapper increaseCoinTimesMapper, UserDataMapper userDataMapper) {
        this.permissionService = permissionService;
        this.userMapper = userMapper;
        this.userInfoMapper = userInfoMapper;
        this.userPhotoMapper = userPhotoMapper;
        this.coinMapper = coinMapper;
        this.increaseCoinTimesMapper = increaseCoinTimesMapper;
        this.userDataMapper = userDataMapper;
    }


    public ResponseEntity<List<Long>> getUserInfoLikeUserName(String name) {
        // sql过滤
        if (!name.matches("^[\u4e00-\u9fa5a-zA-Z0-9]{2,10}$")) {
            return MyResponse.badRequest().build();
        }
        List<Long> byUserNameLike = userInfoMapper.findUidByUserNameLike("%" + name + "%");
//        List<Long> byUserNameLike = userInfoMapper.findUidByUserNameLike(name);
        return MyResponse.responseCode(MyResponse.OK).body(byUserNameLike);
    }

    public ResponseEntity<Void> signUp(String authCode, User user) {
        // 传参效验
        if (user.getEmail() == null || user.getPwd() == null) {
            return MyResponse.badRequest().build();
        }
        // authCode效验
        if (!permissionService.verifyAuthCode(user.getEmail(), authCode, "SIGN_UP")) {
            return MyResponse.responseCode(MyResponse.RES_NOT_MATCH).build();
        }
        // 创建各表，写入外键
        Coin coin = new Coin();
        coin.setCoins(0L);
        coin = coinMapper.save(coin);

        UserPhoto userPhoto = new UserPhoto();
        userPhoto = userPhotoMapper.save(userPhoto);

        UserInfo userInfo = new UserInfo();
        userInfo.setPhotoId(userPhoto.getPhotoId());
        userInfo.setCoinId(coin.getCoinId());
        userInfo.setUserName("default");
        userInfo.setGender("男");
        userInfo.setBirthday("1970-01-01");
        userInfo = userInfoMapper.save(userInfo);

        user.setUid(null);
        user.setInfoId(userInfo.getInfoId());
        userMapper.save(user);

        return MyResponse.responseCode(MyResponse.OK).build();
    }


    public ResponseEntity<Void> resetPwd(String authCode, User user) {
        // 传参效验
        if (user.getEmail() == null || user.getPwd() == null) {
            return MyResponse.badRequest().build();
        }
        // authCode效验
        if (!permissionService.verifyAuthCode(user.getEmail(), authCode, "RESET_PWD")) {
            return MyResponse.responseCode(MyResponse.RES_NOT_MATCH).build();
        }
        // 修改密码
        User localUser = userMapper.findFirstByEmail(user.getEmail());
        localUser.setPwd(user.getPwd());
        userMapper.save(localUser);

        return MyResponse.responseCode(MyResponse.OK).build();
    }

//    public ResponseEntity<User> getUser(String uid) {
//        Optional<User> localUserOptional = userMapper.findById(Long.parseLong(uid));
//        if (!localUserOptional.isPresent()) {
//            return MyResponse.responseCode(MyResponse.OK).build();
//        }
//        else {
//            User user = new User();
//            user.setEmail(localUserOptional.get().getEmail());
//            return MyResponse.responseCode(MyResponse.OK).body(user);
//        }
//    }

    public ResponseEntity<UserInfo> getUserInfo(String uid) {
        UserInfo localUserInfo = userInfoMapper.findUserInfoByUid(Long.parseLong(uid));
        if (localUserInfo == null) {
            return MyResponse.responseCode(MyResponse.OK).body(null);
        } else {
            UserInfo userInfo = new UserInfo();
            userInfo.setUserName(localUserInfo.getUserName());
            userInfo.setGender(localUserInfo.getGender());
            userInfo.setBirthday(localUserInfo.getBirthday());
            return MyResponse.responseCode(MyResponse.OK).body(userInfo);
        }
    }

    public ResponseEntity<byte[]> getUserPhoto(String uid) {
        UserPhoto localUserPhoto = userPhotoMapper.findUserPhotoByUid(Long.parseLong(uid));
        if (localUserPhoto == null) {
            return MyResponse.responseCode(MyResponse.OK).body(null);
        }
        else {
            return MyResponse.responseCode(MyResponse.OK).body(localUserPhoto.getPhoto());
        }
    }

    public ResponseEntity<Long> getCoin(String uid) {
        Coin localCoin = coinMapper.findCoinByUid(Long.parseLong(uid));
        if (localCoin == null) {
            return MyResponse.responseCode(MyResponse.OK).body(null);
        }
        else {
            return MyResponse.responseCode(MyResponse.OK).body(localCoin.getCoins());
        }
    }

    public ResponseEntity<Void> modifyUserInfo(String uid, String token, UserInfo userInfo) {
        Long uidLong = Long.parseLong(uid);
        // 效验token
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 找到UserInf
        UserInfo localUserInfo = userInfoMapper.findUserInfoByUid(uidLong);
        // update selective
        userInfo.setCoinId(null);
        userInfo.setInfoId(null);
        userInfo.setPhotoId(null);
        MyCopyUtils.copySelective(userInfo, localUserInfo);
        userInfoMapper.save(localUserInfo);
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<Void> modifyUserPhoto(String uid, String token, UserPhoto userPhoto) {
        if (userPhoto .getPhoto() == null) {
            return MyResponse.badRequest().build();
        }
        Long uidLong = Long.parseLong(uid);
        // 效验token
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 找到UserPhoto
        UserPhoto localUserPhoto = userPhotoMapper.findUserPhotoByUid(uidLong);
        localUserPhoto.setPhoto(userPhoto.getPhoto());
        userPhotoMapper.save(localUserPhoto);
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<Long> increaseCoin(String uid, String token) {
        Long uidLong = Long.parseLong(uid);
        // 效验token
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 找到Coin
        Coin localCoin = coinMapper.findCoinByUid(uidLong);
        // 是否为cheater
        if (localCoin.getCoins() < 0L) {
            return MyResponse.responseCode(MyResponse.RES_NOT_ALLOW).build();
        }
        // 操作数据库
        // 判断是否作弊 12小时内调用次数
        IncreaseCoinTimes localIncreaseCoinTimes = increaseCoinTimesMapper.findFirstByUid(uidLong);
        if (localIncreaseCoinTimes != null && localIncreaseCoinTimes.getTimes() >= 200) {
            // 超二百次每12小时 作弊封禁 金币置为 -666
            localCoin.setCoins(-666L);
            coinMapper.save(localCoin);
            // 删IncreaseCoinTimes
            increaseCoinTimesMapper.deleteById(localIncreaseCoinTimes.getId());
            return MyResponse.responseCode(MyResponse.RES_NOT_ALLOW).build();
        }
        // 修改coin
        Long randomCoin = ValueBuilder.randomCoin(3, 18);
        localCoin.setCoins(localCoin.getCoins() + randomCoin);
        coinMapper.save(localCoin);
        // 插入或修改IncreaseCoinTimes
        IncreaseCoinTimes increaseCoinTimes = new IncreaseCoinTimes();
        if (localIncreaseCoinTimes == null) {
            // 新建
            increaseCoinTimes.setUid(uidLong);
            increaseCoinTimes.setTimes(1L);
            increaseCoinTimesMapper.insert(increaseCoinTimes);
        } else {
            increaseCoinTimes.setId(localIncreaseCoinTimes.getId());
            increaseCoinTimes.setUid(localIncreaseCoinTimes.getUid());
            increaseCoinTimes.setTimes(localIncreaseCoinTimes.getTimes() + 1L);
            increaseCoinTimes.setCreateDate(localIncreaseCoinTimes.getCreateDate());
            increaseCoinTimesMapper.save(increaseCoinTimes);
        }
        return MyResponse.responseCode(MyResponse.OK).body(randomCoin);
    }

    public ResponseEntity<Void> uploadData(String uid, String token, UserData userData) {
        if (userData.getData() == null) {
            return MyResponse.badRequest().build();
        }
        Long uidLong = Long.parseLong(uid);
        // 效验token
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        // 是否有数据
        UserData localUserData = new UserData();
        localUserData.setUid(uidLong);
        localUserData.setData(userData.getData());
        UserData firstByUid = userDataMapper.findFirstByUid(uidLong);
        if (firstByUid == null) {
            // c
            userDataMapper.insert(localUserData);
        }
        else {
            //u
            localUserData.setId(firstByUid.getId());
            userDataMapper.save(localUserData);
        }
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<byte[]> downloadData(String uid, String token) {
        Long uidLong = Long.parseLong(uid);
        // 效验token
        if (!permissionService.verifyToken(uidLong, token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }
        UserData firstByUid = userDataMapper.findFirstByUid(uidLong);
        if (firstByUid == null) {
            return MyResponse.responseCode(MyResponse.RES_NOT_FOUND).build();
        }
        return MyResponse.responseCode(MyResponse.OK).body(firstByUid.getData());
    }
}

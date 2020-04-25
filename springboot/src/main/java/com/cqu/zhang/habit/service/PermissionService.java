package com.cqu.zhang.habit.service;

import com.cqu.zhang.habit.common.ValueBuilder;
import com.cqu.zhang.habit.common.MyResponse;
import com.cqu.zhang.habit.entity.mongo.AuthCode;
import com.cqu.zhang.habit.entity.mongo.Token;
import com.cqu.zhang.habit.entity.mysql.User;
import com.cqu.zhang.habit.mapper.mongo.AuthCodeMapper;
import com.cqu.zhang.habit.mapper.mongo.TokenMapper;
import com.cqu.zhang.habit.mapper.mysql.UserMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class PermissionService {
    final
    TokenMapper tokenMapper;
    final
    UserMapper userMapper;
    final
    MailService mailService;
    final
    AuthCodeMapper authCodeMapper;

    public PermissionService(TokenMapper tokenMapper, UserMapper userMapper, MailService mailService, AuthCodeMapper authCodeMapper) {
        this.tokenMapper = tokenMapper;
        this.userMapper = userMapper;
        this.mailService = mailService;
        this.authCodeMapper = authCodeMapper;
    }

    public boolean verifyToken(Long uid, String token) {
        if (uid == null || token == null) {
            return false;
        }
        Token firstByUid = tokenMapper.findFirstByUid(uid);
        if (firstByUid == null) {
            return false;
        } else {
            return token.equals(firstByUid.getToken());
        }
    }

    public boolean verifyAuthCode(String email, String authCode, String purpose) {
        if (email == null || authCode == null || purpose == null || purpose.isEmpty()) {
            return false;
        }
        AuthCode firstByUid = authCodeMapper.findFirstByEmail(email);
        if (firstByUid != null) {
            if (authCode.equals(firstByUid.getAuthCode()) && purpose.equals(firstByUid.getPurpose())) {
                authCodeMapper.deleteById(firstByUid.getId());
                return true;
            }
        }
        return false;
    }

    public ResponseEntity<Boolean> getTokenState(Long uid, String token) {
        return MyResponse.responseCode(MyResponse.OK).body(verifyToken(uid, token));
    }

    public ResponseEntity<Token> signIn(User user) {
        // 传参效验
        if (user.getEmail() == null || user.getPwd() == null) {
            return MyResponse.responseCode(MyResponse.RES_NOT_MATCH).build();
        }
        // 密码效验
        User firstByEmail = userMapper.findFirstByEmail(user.getEmail());
        if (firstByEmail == null || !user.getPwd().equals(firstByEmail.getPwd())) {
            return MyResponse.responseCode(MyResponse.RES_NOT_MATCH).build();
        }
        // 删除token
        tokenMapper.deleteByUid(firstByEmail.getUid());
        // 插入token
        Token token = new Token();
        token.setUid(firstByEmail.getUid());
        token.setToken(ValueBuilder.createTokenString(token.getUid()));
        tokenMapper.insert(token);
        token.setCreateDate(null);
        return MyResponse.responseCode(MyResponse.OK).body(token);
    }

    public ResponseEntity<Void> createAuthCode(AuthCode authCode) {
        // 传参效验
        if (authCode.getEmail() == null || authCode.getPurpose() == null || authCode.getPurpose().isEmpty()) {
            return MyResponse.badRequest().build();
        }
        // 查重效验
        User localUser = userMapper.findFirstByEmail(authCode.getEmail());
        if ("SIGN_UP".equals(authCode.getPurpose())) {
            if (localUser != null) {
                return MyResponse.responseCode(MyResponse.RES_REPEATED).build();
            }
        } else if ("RESET_PWD".equals(authCode.getPurpose())) {
            if (localUser == null) {
                return MyResponse.responseCode(MyResponse.RES_NOT_FOUND).build();
            }
        } else {
            return MyResponse.badRequest().build();
        }
        // 删除authCode
        authCodeMapper.deleteByEmail(authCode.getEmail());
        // 插入authCode
        authCode.setCreateDate(new Date());
        authCode.setAuthCode(ValueBuilder.createSixDigitNum());
        authCodeMapper.insert(authCode);
        // 发送邮件
        if ("SIGN_UP".equals(authCode.getPurpose())) {
            if (!mailService.sendSignUpAuthCodeEmail(authCode.getEmail(), authCode.getAuthCode())) {
                return MyResponse.responseCode(MyResponse.CREATE_FAIL).build();
            }
        } else if ("RESET_PWD".equals(authCode.getPurpose())) {
            if (!mailService.sendResetPwdAuthCodeEmali(authCode.getEmail(), authCode.getAuthCode())) {
                return MyResponse.responseCode(MyResponse.CREATE_FAIL).build();
            }
        }
        return MyResponse.responseCode(MyResponse.OK).build();
    }
}

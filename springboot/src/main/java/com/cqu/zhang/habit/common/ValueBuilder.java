package com.cqu.zhang.habit.common;

import org.springframework.util.DigestUtils;

import java.util.Random;

public class ValueBuilder {
    private static final Random random = new Random();

    public static String createSixDigitNum() {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            stringBuilder.append((char) ('0' + random.nextInt(10)));
        }
        return stringBuilder.toString();
    }

    public static String createTokenString(Long uid) {
        String token = "habit" + uid + System.currentTimeMillis();
        return DigestUtils.md5DigestAsHex(token.getBytes());
    }

    public static Long randomCoin(int leftBorder, int rightBorder) {
        return (long) (leftBorder + random.nextInt(rightBorder - leftBorder + 1));
    }
}

package com.cqu.zhang.habit.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.security.Security;
import java.util.Date;
import java.util.Properties;

@Service
public class MailService {
    @Value("${spring.mail.username}")
    private String from;
    @Value("${spring.mail.password}")
    private String psw;

    @Value("${spring.mail.host}")
    private String host;

    public boolean sendSignUpAuthCodeEmail(String email, String authCode) {
//        System.out.println(authCode);
//        System.out.println(email);
        try {
            String s = "" +
                    "[Habit]\n" +
                    "您好，欢迎您注册Habit账号\n" +
                    "授权码为 [" + authCode + "] 非本人操作请无视本邮件\n" +
                    "Auth code is: [" + authCode + "] please ignore this email if you are not operating by yourself\n";
            sendEmil(email, "Habit 注册", s);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendPurchaseGoodsTokenEmail(String email, String name, String goodsToken) {
//        System.out.println(authCode);
//        System.out.println(email);
        try {
            String s = "" +
                    "[Habit]\n" +
                    "您好，感谢您购买" + name + "商品\n" +
                    "您的口令如下：\n" +
                    goodsToken + "\n" +
                    "Hello, thank you for your purchase\n" +
                    "Your goods token is as follows:\n" +
                    goodsToken + "\n";
            sendEmil(email, "Habit 购买回执", s);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendResetPwdAuthCodeEmali(String email, String authCode) {
//        System.out.println(authCode);
//        System.out.println(email);
        try {
            String s = ""
                    + "[Habit]\n"
                    + "您的账号正在重置密码\n"
                    + "授权码为 [" + authCode + "] 非本人操作请无视本邮件\n"
                    + "Auth code is: [" + authCode + "] please ignore this email if you are not operating by yourself\n";
            sendEmil(email, "Habit 重置密码", s);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void sendEmil(String to, String subject, String message) throws MessagingException {
        Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
        //设置邮件会话参数
        Properties props = new Properties();
        //邮箱的发送服务器地址
        props.setProperty("mail.smtp.host", host);
        props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
        props.setProperty("mail.smtp.socketFactory.fallback", "false");
        //邮箱发送服务器端口,这里设置为465端口
        props.setProperty("mail.smtp.port", "465");
        props.setProperty("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.auth", "true");
        final String username = from;
        final String password = psw;
        //获取到邮箱会话,利用匿名内部类的方式,将发送者邮箱用户名和密码授权给jvm
        Session session = Session.getDefaultInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        //通过会话,得到一个邮件,用于发送
        Message msg = new MimeMessage(session);
        //设置发件人
        msg.setFrom(new InternetAddress(from));
        //设置收件人,to为收件人,cc为抄送,bcc为密送
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse(to, false));
        msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(to, false));
        msg.setSubject(subject);
        //设置邮件消息
        msg.setText(message);
        //设置发送的日期
        msg.setSentDate(new Date());

        //调用Transport的send方法去发送邮件
        Transport.send(msg);

    }
}

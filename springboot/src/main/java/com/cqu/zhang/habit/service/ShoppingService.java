package com.cqu.zhang.habit.service;

import com.cqu.zhang.habit.common.MyCopyUtils;
import com.cqu.zhang.habit.common.MyResponse;
import com.cqu.zhang.habit.entity.mysql.Coin;
import com.cqu.zhang.habit.entity.mysql.Goods;
import com.cqu.zhang.habit.entity.mysql.Purchased;
import com.cqu.zhang.habit.entity.mysql.User;
import com.cqu.zhang.habit.mapper.mysql.CoinMapper;
import com.cqu.zhang.habit.mapper.mysql.GoodsMapper;
import com.cqu.zhang.habit.mapper.mysql.PurchasedMapper;
import com.cqu.zhang.habit.mapper.mysql.UserMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional(rollbackFor = Exception.class)
public class ShoppingService {
    final
    CoinMapper coinMapper;
    final
    GoodsMapper goodsMapper;
    final
    PurchasedMapper purchasedMapper;
    final
    PermissionService permissionService;
    final
    MailService mailService;
    final
    UserMapper userMapper;

    public ShoppingService(CoinMapper coinMapper, GoodsMapper goodsMapper, PurchasedMapper purchasedMapper, PermissionService permissionService, MailService mailService, UserMapper userMapper) {
        this.coinMapper = coinMapper;
        this.goodsMapper = goodsMapper;
        this.purchasedMapper = purchasedMapper;
        this.permissionService = permissionService;
        this.mailService = mailService;
        this.userMapper = userMapper;
    }

    public ResponseEntity<List<Goods>> getGoodsList() {
        List<Goods> all = goodsMapper.findAll();
        List<Goods> out = new LinkedList<>();
        for (Goods goods : all) {
            Goods goods1 = new Goods();
            BeanUtils.copyProperties(goods, goods1);
            goods1.setGoodsToken(null);
            out.add(goods1);
        }
        return MyResponse.responseCode(MyResponse.OK).body(out);
    }

    public ResponseEntity<Void> buyGoods(String token, Purchased purchased) {
        // 数据效验
        if (purchased.getUid() == null || purchased.getGoodsId() == null) {
            return MyResponse.badRequest().build();
        }
        // token 效验
        if (!permissionService.verifyToken(purchased.getUid(), token)) {
            return MyResponse.responseCode(MyResponse.INVALID_AUTHORIZE).build();
        }

        // 找出商品
        Optional<Goods> localGoodsOptional = goodsMapper.findById(purchased.getGoodsId());
        if (!localGoodsOptional.isPresent()) {
            return MyResponse.badRequest().build();
        }
        Goods localGoods = localGoodsOptional.get();

        // 是否购买
        Purchased localPurchased = purchasedMapper.findFirstByGoodsId(purchased.getGoodsId());
        if (localPurchased == null) {
            // 未购买
            Coin coin = coinMapper.findCoinByUid(purchased.getUid());
            if (coin.getCoins() < localGoods.getPrice()) {
                // 钱不够
                return MyResponse.responseCode(MyResponse.RES_NOT_ALLOW).build();
            } else {
                // 钱够
                // 存货是否够
                if (localGoods.getCount() <= 0) {
                    // 存货不够
                    return MyResponse.responseCode(MyResponse.RES_NOT_MATCH).build();
                }
                // 减钱*
                coin.setCoins(coin.getCoins() - localGoods.getPrice());
                coinMapper.save(coin);
                // 减存货*
                localGoods.setCount(localGoods.getCount() - 1);
                goodsMapper.save(localGoods);
                // 记录已购*
                purchased.setId(null);
                purchasedMapper.save(purchased);
            }
        }
        // 已购买 发邮件
        Optional<User> localUserOptional = userMapper.findById(purchased.getUid());
        if (!localUserOptional.isPresent()) {
            return MyResponse.badRequest().build();
        }
        User localUser = localUserOptional.get();
        if(!mailService.sendPurchaseGoodsTokenEmail(localUser.getEmail(), localGoods.getName(), localGoods.getGoodsToken())) {
            return MyResponse.responseCode(MyResponse.CREATE_FAIL).build();
        }
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<List<Goods>> selectGoodsList() {
        List<Goods> all = goodsMapper.findAll();
        return MyResponse.responseCode(MyResponse.OK).body(all);
    }

    public ResponseEntity<Void> modifyGoods(Goods goods) {
        Optional<Goods> localGoodsOptional = goodsMapper.findById(goods.getGoodsId());
        if (!localGoodsOptional.isPresent()) {
            return MyResponse.badRequest().build();
        }
        Goods localGoods = localGoodsOptional.get();
        MyCopyUtils.copySelective(goods,localGoods);
        goodsMapper.save(localGoods);
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<Void> deleteGoods(String id) {
        Long idLong = Long.parseLong(id);
        goodsMapper.deleteById(idLong);
        return MyResponse.responseCode(MyResponse.OK).build();
    }

    public ResponseEntity<Void> creatGoods(Goods goods) {
        goods.setGoodsId(null);
        goodsMapper.save(goods);
        return MyResponse.responseCode(MyResponse.OK).build();
    }
}

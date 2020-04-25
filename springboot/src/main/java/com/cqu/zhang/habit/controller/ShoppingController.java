package com.cqu.zhang.habit.controller;

import com.cqu.zhang.habit.entity.mysql.Goods;
import com.cqu.zhang.habit.entity.mysql.Purchased;
import com.cqu.zhang.habit.service.ShoppingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shopping")
public class ShoppingController {
    final
    ShoppingService shoppingService;

    public ShoppingController(ShoppingService shoppingService) {
        this.shoppingService = shoppingService;
    }

    @GetMapping("/")
    ResponseEntity<List<Goods>> getGoodsList() {
        return shoppingService.getGoodsList();
    }

    @PostMapping("/")
    ResponseEntity<Void> buyGoods(@RequestHeader String token, @RequestBody Purchased purchased) {
        return shoppingService.buyGoods(token, purchased);
    }

    @GetMapping("/goods")
    ResponseEntity<List<Goods>> selectGoodsList() {
        return shoppingService.selectGoodsList();
    }

    @PostMapping("/goods")
    ResponseEntity<Void> creatGoods(@RequestBody Goods goods) {
        return shoppingService.creatGoods(goods);
    }

    @DeleteMapping("/goods/{id}")
    ResponseEntity<Void> deleteGoods(@PathVariable String id) {
        return shoppingService.deleteGoods(id);
    }

    @PutMapping("/goods")
    ResponseEntity<Void> modifyGoods(@RequestBody Goods goods) {
        return shoppingService.modifyGoods(goods);
    }
}

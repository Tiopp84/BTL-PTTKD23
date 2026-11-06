package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class OrderedDish9 {
    private int id;
    private Date createdAt;
    private int qty;
    private String status;
    private Dish9 dish;
    private Double price;

    public OrderedDish9(int id, Date createdAt, int qty, String status, Dish9 dish, Double price) {
        this.id = id;
        this.createdAt = createdAt;
        this.qty = qty;
        this.status = status;
        this.dish = dish;
        this.price = price;
    }
}

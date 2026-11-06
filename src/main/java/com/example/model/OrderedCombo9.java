package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class OrderedCombo9 {
    private int id;
    private Date createdAt;
    private int qty;
    private String status;
    private Combo9 combo;
    private Double price;

    public OrderedCombo9(int id, Date createdAt, int qty, String status, Combo9 combo, Double price) {
        this.id = id;
        this.createdAt = createdAt;
        this.qty = qty;
        this.status = status;
        this.combo = combo;
        this.price = price;
    }
}

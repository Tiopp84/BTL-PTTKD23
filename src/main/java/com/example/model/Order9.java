package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class Order9 {
    private int id;
    private Date createdAt;
    private String note;
    private Double total;
    private String status;
    private Customer9 customer;
    private Waiter9 staff;
    private List<ReservedTable9> table;
    private List<OrderedDish9> dish;
    private List<OrderedCombo9> combo;

    public Order9(int id, Date createdAt, String note, Double total, String status, Customer9 customer, Waiter9 staff, List<ReservedTable9> table, List<OrderedDish9> dish, List<OrderedCombo9> combo) {
        this.id = id;
        this.createdAt = createdAt;
        this.note = note;
        this.total = total;
        this.status = status;
        this.customer = customer;
        this.staff = staff;
        this.table = table;
        this.dish = dish;
        this.combo = combo;
    }
}

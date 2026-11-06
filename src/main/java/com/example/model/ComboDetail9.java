package com.example.model;

public class ComboDetail9 {
    private int id;
    private int qty;
    private Dish9 dish;

    public ComboDetail9() {
    }

    public ComboDetail9(int id, int qty, Dish9 dish) {
        this.id = id;
        this.qty = qty;
        this.dish = dish;
    }

    public int getId() { return id; }
    public int getQty() { return qty; }
    public Dish9 getDish() { return dish; }
}

package com.example.model;

public class ImportDetail9 {
    private int id;
    private Double price;
    private int qty;
    private Material9 material;

    public ImportDetail9() {
    }

    public ImportDetail9(int id, Double price, int qty, Material9 material) {
        this.id = id;
        this.price = price;
        this.qty = qty;
        this.material = material;
    }

    public int getId() { return id; }
    public Double getPrice() { return price; }
    public int getQty() { return qty; }
    public Material9 getMaterial() { return material; }
}

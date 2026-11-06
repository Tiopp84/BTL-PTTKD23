package com.example.model;

public class Material9 {
    private int id;
    private String name;
    private String unit;
    private String description;
    private int stock;

    public Material9() {
    }

    public Material9(int id, String name, String unit, String description, int stock) {
        this.id = id;
        this.name = name;
        this.unit = unit;
        this.description = description;
        this.stock = stock;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getUnit() { return unit; }
    public String getDescription() { return description; }
    public int getStock() { return stock; }
}

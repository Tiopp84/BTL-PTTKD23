package com.example.model;

import java.util.List;

public class Combo9 {
    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private Double price;
    private List<ComboDetail9> listDish;

    public Combo9() {
    }

    public Combo9(int id, String name, String description, String imageUrl, Double price, List<ComboDetail9> listDish) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
        this.listDish = listDish;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getImageUrl() { return imageUrl; }
    public Double getPrice() { return price; }
    public List<ComboDetail9> getListDish() { return listDish; }
}

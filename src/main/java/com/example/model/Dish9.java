package com.example.model;

public class Dish9 {
    private int id;
    private String name;
    private String unit;
    private String description;
    private String imageUrl;
    private Double price;

    public Dish9() {
    }

    public Dish9(int id, String name, String unit, String description, String imageUrl, Double price) {
        this.id = id;
        this.name = name;
        this.unit = unit;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getUnit() { return unit; }
    public String getDescription() { return description; }
    public String getImageUrl() { return imageUrl; }
    public Double getPrice() { return price; }

    @Override
    public String toString() {
        return "Dish9 [id=" + id + ", name=" + name + ", unit=" + unit + ", description=" + description + ", imageUrl="
                + imageUrl + ", price=" + price + "]";
    }
    
}

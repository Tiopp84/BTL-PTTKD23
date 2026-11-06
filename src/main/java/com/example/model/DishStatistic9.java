package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class DishStatistic9 extends Dish9 {
    private int usage;
    private String frequency;

    public DishStatistic9(int id, String name, String unit, String description, String imageUrl, Double price, int usage, String frequency) {
        super(id, name, unit, description, imageUrl, price);
        this.usage = usage;
        this.frequency = frequency;
    }
}

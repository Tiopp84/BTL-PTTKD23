package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class MaterialStatistic9 extends Material9 {
    private int usage;
    private Double timeInStock;

    public MaterialStatistic9(int id, String name, String unit, String description, int stock, int usage, Double timeInStock) {
        super(id, name, unit, description, stock);
        this.usage = usage;
        this.timeInStock = timeInStock;
    }
}

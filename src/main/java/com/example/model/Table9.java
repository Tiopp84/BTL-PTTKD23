package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class Table9 {
    private int id;
    private String description;
    private int slot;
    private Double basePrice;
    private String status;

    public Table9(int id, String description, int slot, Double basePrice, String status) {
        this.id = id;
        this.description = description;
        this.slot = slot;
        this.basePrice = basePrice;
        this.status = status;
    }
}

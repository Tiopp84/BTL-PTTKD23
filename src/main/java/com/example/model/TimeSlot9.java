package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class TimeSlot9 {
    private int id;
    private String description;
    private Double priceMultiplier;

    public TimeSlot9(int id, String description, Double priceMultiplier) {
        this.id = id;
        this.description = description;
        this.priceMultiplier = priceMultiplier;
    }
}

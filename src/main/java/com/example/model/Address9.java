package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class Address9 {
    private int id;
    private String houseNumber;
    private String street;
    private String ward;
    private String city;

    public Address9(int id, String houseNumber, String street, String ward, String city) {
        this.id = id;
        this.houseNumber = houseNumber;
        this.street = street;
        this.ward = ward;
        this.city = city;
    }
}

package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class CustomerStatistic9 extends Customer9 {
    private int totalCome;
    private Double totalPayment;

    public CustomerStatistic9(int id, String userName, String password, Date dob, String email, String gender, String phone, Date createdAt, Fullname9 name, Address9 address, String status, int totalCome, Double totalPayment) {
        super(id, userName, password, dob, email, gender, phone, createdAt, name, address, status);
        this.totalCome = totalCome;
        this.totalPayment = totalPayment;
    }
}

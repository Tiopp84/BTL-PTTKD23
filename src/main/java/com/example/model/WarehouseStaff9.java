package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class WarehouseStaff9 extends Staff9 {

    public WarehouseStaff9(int id, String userName, String password, Date dob, String email, String gender, String phone, Date createdAt, Fullname9 name, Address9 address, String status, String role) {
        super(id, userName, password, dob, email, gender, phone, createdAt, name, address, status, role);
    }
}

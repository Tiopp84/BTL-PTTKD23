package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class Member9 {
    private int id;
    private String userName;
    private String password;
    private Date dob;
    private String email;
    private String gender;
    private String phone;
    private Date createdAt;
    private Fullname9 name;
    private Address9 address;
    private String status;

    public Member9(int id, String userName, String password, Date dob, String email, String gender, String phone, Date createdAt, Fullname9 name, Address9 address, String status) {
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.dob = dob;
        this.email = email;
        this.gender = gender;
        this.phone = phone;
        this.createdAt = createdAt;
        this.name = name;
        this.address = address;
        this.status = status;
    }

    public int getId() { return id; }
    public String getUserName() { return userName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public Fullname9 getName() { return name; }
    public String getStatus() { return status; }
}

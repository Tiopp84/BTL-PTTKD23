package com.example.model;

public class Supplier9 {
    private int id;
    private String name;
    private String phone;
    private String email;
    private String description;
    private Address9 address;

    public Supplier9() {
    }

    public Supplier9(int id, String name, String phone, String email, String description, Address9 address) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.description = description;
        this.address = address;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getDescription() { return description; }
    public Address9 getAddress() { return address; }
}

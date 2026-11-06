package com.example.model;

public class SupplierStatistic9 extends Supplier9 {
    private int totalImport;
    private Double totalPayment;

    public SupplierStatistic9() {
    }

    public SupplierStatistic9(int id, String name, String phone, String email, String description, Address9 address, int totalImport, Double totalPayment) {
        super(id, name, phone, email, description, address);
        this.totalImport = totalImport;
        this.totalPayment = totalPayment;
    }

    public int getTotalImport() { return totalImport; }
    public Double getTotalPayment() { return totalPayment; }

}

package com.example.model;

import java.util.Date;
import java.util.List;

public class ImportInvoice9 {
    private int id;
    private Double total;
    private Date createdAt;
    private String note;
    private WarehouseStaff9 staff;
    private Supplier9 supplier;
    private List<ImportDetail9> listImport;

    public ImportInvoice9() {
    }

    public ImportInvoice9(int id, Double total, Date createdAt, String note, WarehouseStaff9 staff, Supplier9 supplier, List<ImportDetail9> listImport) {
        this.id = id;
        this.total = total;
        this.createdAt = createdAt;
        this.note = note;
        this.staff = staff;
        this.supplier = supplier;
        this.listImport = listImport;
    }

    public int getId() { return id; }
    public Double getTotal() { return total; }
    public Date getCreatedAt() { return createdAt; }
    public String getNote() { return note; }
    public WarehouseStaff9 getStaff() { return staff; }
    public Supplier9 getSupplier() { return supplier; }
    public List<ImportDetail9> getListImport() { return listImport; }
}

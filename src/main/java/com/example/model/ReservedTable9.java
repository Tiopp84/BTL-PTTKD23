package com.example.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class ReservedTable9 {
    private int id;
    private Date createdAt;
    private Date checkIn;
    private Date checkOut;
    private Table9 table;
    private TimeSlot9 timeSlot;

    public ReservedTable9(int id, Date createdAt, Date checkIn, Date checkOut, Table9 table, TimeSlot9 timeSlot) {
        this.id = id;
        this.createdAt = createdAt;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.table = table;
        this.timeSlot = timeSlot;
    }
}

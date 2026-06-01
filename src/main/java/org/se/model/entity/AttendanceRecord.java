package org.se.model.entity;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class AttendanceRecord {
    public Integer recordID;
    public String studentID;
    public LocalDate attendanceDate;
    public Boolean absent;
}

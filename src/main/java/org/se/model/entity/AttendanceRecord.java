package org.se.model.entity;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class AttendanceRecord {
    public int recordID;
    public String studentID;
    public Date attendanceDate;
    public int isAbsent;
}

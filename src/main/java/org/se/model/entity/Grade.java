package org.se.model.entity;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Grade {
    public String studentID;
    public String courseID;
    public BigDecimal regularGrade;
    public BigDecimal finalGrade;
    public BigDecimal totalGrade;
}

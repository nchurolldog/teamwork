package org.se.model.entity;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Course {
    public String courseID;
    public String courseName;
    public BigDecimal credits;
}

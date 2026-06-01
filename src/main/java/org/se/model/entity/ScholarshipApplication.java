package org.se.model.entity;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ScholarshipApplication {
    public String appID;
    public String studentID;
    public String typeCode;
    public BigDecimal amount;
    public String reason;
    public String status;
}

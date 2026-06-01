package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Teacher {
    public String employeeID;
    public String account;
    public String name;
    public Integer gender;
}

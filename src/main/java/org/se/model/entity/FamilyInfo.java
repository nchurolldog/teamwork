package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class FamilyInfo {
    public String studentID;
    public String homeAddress;
    public Integer familySize;
    public String phone;
}

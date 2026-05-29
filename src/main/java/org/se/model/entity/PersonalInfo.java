package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class PersonalInfo {
    public String studentID;
    public String originPlace;
    public String politicalStatus;
}

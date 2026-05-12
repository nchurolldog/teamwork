package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class PartyApplication {
    public String applicationID;
    public String applicantStudentID;
    public String reason;
    public String status;
}

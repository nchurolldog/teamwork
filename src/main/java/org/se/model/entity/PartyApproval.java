package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class PartyApproval {
    public String approvalID;
    public String applicationID;
    public String approverEmployeeID;
    public String status;
}

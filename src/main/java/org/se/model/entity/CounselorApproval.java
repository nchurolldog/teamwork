package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class CounselorApproval {
    public String appID;
    public String employeeID;
    public String result;
}

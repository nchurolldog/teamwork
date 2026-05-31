package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class DevelopmentInspection {
    public String inspectionID;
    public String applicationID;
    public String inspectorEmployeeID;
    public String status;
}

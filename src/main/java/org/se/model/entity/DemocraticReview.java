package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class DemocraticReview {
    public String reviewID;
    public String applicationID;
    public String organizerEmployeeID;
    public String status;
}

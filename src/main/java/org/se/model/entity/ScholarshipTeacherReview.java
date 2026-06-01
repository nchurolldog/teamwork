package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScholarshipTeacherReview {
    private String reviewID;
    private String appID;
    private String employeeID;
    private Boolean result;
    private String comment;
    private String status;
}

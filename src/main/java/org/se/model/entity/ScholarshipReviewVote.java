package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScholarshipReviewVote {
    private String reviewID;
    private String voterStudentID;
    private Boolean agree;
    private String comment;
}

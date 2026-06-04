package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class DemocraticReviewParticipant {
    public String reviewID;
    public String participantStudentID;
    public Integer access;
}

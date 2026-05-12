package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ClassMeetingAssociation {
    public String meetingID;
    public String studentID;
}

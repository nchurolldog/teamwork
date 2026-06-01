package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ClassMeeting {
    public String meetingID;
    public Integer classID;
    public String meetingTheme;
    public String classroom;
}

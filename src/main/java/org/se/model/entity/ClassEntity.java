package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ClassEntity {
    public Integer classID;
    public String className;
    public String teacherID;
    public String counselorID;
}

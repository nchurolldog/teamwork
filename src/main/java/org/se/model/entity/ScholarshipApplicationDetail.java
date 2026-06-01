package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScholarshipApplicationDetail {
    private String appID;
    private BigDecimal requestedAmount;
    private String familySituation;
    private String academicScore;
    private String conductEvaluation;
    private String honors;
    private String applicationReason;
    private String supportingMaterials;
    private Boolean promise;
}

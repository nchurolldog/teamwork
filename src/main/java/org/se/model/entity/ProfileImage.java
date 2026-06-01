package org.se.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileImage {
    private Integer imageID;
    private Integer ownerType;
    private String ownerAccount;
    private String imagePath;
    private String originalName;
    private String contentType;
    private LocalDateTime updatedAt;
}

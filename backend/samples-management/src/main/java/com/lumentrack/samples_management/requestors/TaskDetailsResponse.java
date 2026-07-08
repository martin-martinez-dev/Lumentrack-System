package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TaskDetailsResponse {
    private Integer taskId;
    private String taskName;
    private String taskDescription;
    private String taskPhotoUrl;
    private String taskPhotoId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate taskEstimatedDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate taskRealDateTime;
    // No incluimos el componente padre aquí para evitar ciclos de serialización
    // Si se necesita, se puede añadir un ID o nombre simple
    private Integer componentId;
    private String componentName;
}
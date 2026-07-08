package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;

@Data
public class TaskRequest {
    private Integer taskId; // Puede ser null para nuevas tareas
    private Integer componentId; // El ID del componente al que pertenece la tarea
    private String taskName;
    private String taskDescription;
    private String taskPhotoUrl;
    private String taskPhotoId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate taskEstimatedDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate taskRealDateTime;
}
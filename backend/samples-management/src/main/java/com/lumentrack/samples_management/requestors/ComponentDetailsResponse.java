package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ComponentDetailsResponse {
    private Integer componentId;
    private String componentName;
    private String componentType;
    private String componentDescription;
    private String componentPhotoUrl;
    private String componentPhotoId;
    private Boolean isExternal;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate deliveryDate;
    private Integer materialId;
    private String materialName; // Campo Transient
    private String statusResume;
    private String ulaLightEmployee;
    private Integer userId;
    // No incluimos el sample padre aquí para evitar ciclos de serialización
    // Si se necesita, se puede añadir un ID o nombre simple
    private Integer sampleId;
    private String sampleName;

    private List<TaskDetailsResponse> tasks; // Lista de tareas asociadas
}
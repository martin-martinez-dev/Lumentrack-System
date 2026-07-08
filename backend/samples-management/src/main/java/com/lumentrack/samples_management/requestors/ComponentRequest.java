package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class ComponentRequest {
    private Integer componentId; // Puede ser null para nuevos componentes
    private Integer sampleId; // El ID de la muestra a la que pertenece el componente
    private String componentName;
    private String componentType;
    private String componentDescription;
    private String componentPhotoUrl;
    private String componentPhotoId;
    private Boolean isExternal;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate deliveryDate;
    private Integer materialId;
    private String statusResume;
    private String ulaLightEmployee;
    private Integer userId; // El ID del usuario asignado
    // No incluimos 'tasks' directamente aquí si se manejan en otro endpoint o de forma separada
}
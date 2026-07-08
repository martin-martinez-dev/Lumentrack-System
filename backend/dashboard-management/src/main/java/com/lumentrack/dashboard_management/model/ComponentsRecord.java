package com.lumentrack.dashboard_management.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDate;
import java.util.List;

public record ComponentsRecord (
    Integer componentId,
    // No incluimos SamplesRecord aquí para evitar ciclos infinitos en el mapeo
    // Si se necesita el sampleId o sampleName, se puede añadir directamente
    Integer sampleId, // Para referencia al Sample padre
    String sampleName, // Para mostrar el nombre del Sample
    String componentName,
    String componentType,
    String componentDescription,
    String componentPhotoUrl,
    String componentPhotoId,
    Boolean isExternal,
    @JsonFormat(pattern = "yyyy-MM-dd")
    LocalDate deliveryDate,
    Integer materialId,
    String materialName,
    String statusResume,
    String ulaLightEmployee,
    Integer userId, // Nuevo campo
    List<TasksRecord> tasks // Relación con Tasks
) { }
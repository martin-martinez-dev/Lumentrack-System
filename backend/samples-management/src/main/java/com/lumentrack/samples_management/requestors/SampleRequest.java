package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

// Este DTO representa la estructura de datos que esperamos del frontend al crear/actualizar una muestra
@Data
public class SampleRequest {
    private Integer sampleId; // Puede ser null para nuevas muestras
    private Integer orderId; // El ID de la orden a la que pertenece la muestra
    private String sampleName;
    private String samplePhotoUrl;
    private String samplePhotoId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate estimatedDeliveryDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate realDeliveryDate;
    // No incluimos 'components' directamente aquí si se manejan en otro endpoint o de forma separada
    // Si el frontend envía una lista de IDs de componentes, se podría añadir List<Integer> componentIds;
}
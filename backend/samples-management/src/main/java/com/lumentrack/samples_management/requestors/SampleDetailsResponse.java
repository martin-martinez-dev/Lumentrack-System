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
public class SampleDetailsResponse {
    private Integer sampleId;
    private String sampleName;
    private String samplePhotoUrl;
    private String samplePhotoId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate estimatedDeliveryDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate realDeliveryDate;
    // No incluimos el order padre aquí para evitar ciclos de serialización
    // Si se necesita, se puede añadir un ID o nombre simple
    private Integer orderId;
    private String orderName;

    private List<ComponentDetailsResponse> components; // Lista de componentes asociados
}
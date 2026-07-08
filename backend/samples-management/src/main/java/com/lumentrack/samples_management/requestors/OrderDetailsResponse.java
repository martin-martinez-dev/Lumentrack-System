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
public class OrderDetailsResponse {
    private Integer orderId;
    private String orderNumber;
    private String orderName;
    private Integer clientId;
    private String clientName; // Campo Transient
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate estimatedDeliveryDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate realDeliveryDate;

    private List<SampleDetailsResponse> samples; // Lista de muestras asociadas
}
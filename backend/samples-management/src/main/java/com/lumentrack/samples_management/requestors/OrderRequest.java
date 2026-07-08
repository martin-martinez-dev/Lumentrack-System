package com.lumentrack.samples_management.requestors;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;

@Data
public class OrderRequest {
    private Integer orderId; // Puede ser null para nuevas órdenes
    private String orderNumber;
    private String orderName;
    private Integer clientId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate estimatedDeliveryDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate realDeliveryDate;
    // No incluimos 'samples' directamente aquí si se manejan en otro endpoint o de forma separada
}
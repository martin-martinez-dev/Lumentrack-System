package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;
import java.util.List; // Nueva importación

import com.fasterxml.jackson.annotation.JsonFormat;

public record OrdersRecord (
	Integer orderId,
	String orderNumber,
	String orderName,
	Integer clientId,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate realDeliveryDate,
	List<SamplesRecord> samples // Nuevo campo para la relación
) { }
package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;
import java.util.List; // Nueva importación

import com.fasterxml.jackson.annotation.JsonFormat;

public record SamplesRecord (
	Integer sampleId,
	// Integer orderId, // Reemplazado por la referencia a OrdersRecord
	OrdersRecord order, // Referencia al Order padre (puede ser un DTO simplificado si es necesario)
	String sampleName,
	String samplePhotoUrl,
	String samplePhotoId,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate realDeliveryDate,
	List<ComponentsRecord> components // Nuevo campo para la relación
) { }
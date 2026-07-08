package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;
import java.util.List; // Nueva importación

import com.fasterxml.jackson.annotation.JsonFormat;

public record SamplesRecord (
	Integer sampleId,
	// Eliminado: OrdersRecord order, // Reemplazado por orderId y orderName
	Integer orderId, // Añadido: ID del Order padre
	String orderName, // Añadido: Nombre del Order padre
	String sampleName,
	String samplePhotoUrl,
	String samplePhotoId,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate realDeliveryDate,
	List<ComponentsRecord> components // Nuevo campo para la relación
) { }
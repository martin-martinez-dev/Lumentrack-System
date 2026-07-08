package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonFormat;

public record TasksRecord (
	Integer taskId,
	String taskName,
	String taskDescription,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate taskEstimatedDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate taskRealDateTime,
	// Eliminado: ComponentsRecord component // Reemplazado por componentId y componentName
	Integer componentId, // Añadido: ID del Component padre
	String componentName // Añadido: Nombre del Component padre
) { }
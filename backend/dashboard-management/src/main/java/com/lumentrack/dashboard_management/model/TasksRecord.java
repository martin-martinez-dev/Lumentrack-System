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
	// Integer componentId, // Reemplazado por la referencia a ComponentsRecord
	ComponentsRecord component // Referencia al Component padre (puede ser un DTO simplificado si es necesario)
) { }
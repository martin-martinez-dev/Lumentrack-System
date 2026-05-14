package com.lumentrack.dashboard_management.model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

public record TasksRecord (
	Integer taskId,
	String taskName,
	String taskDescription,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime taskEstimatedDate,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime taskRealDateTime
) { }

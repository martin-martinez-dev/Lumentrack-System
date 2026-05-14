package com.lumentrack.dashboard_management.model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

public record SamplesRecord (
	Integer sampleId,
	Integer orderId,
	String sampleName,
	String samplePhotoUrl,
	String samplePhotoId,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime realDeliveryDate
) { }

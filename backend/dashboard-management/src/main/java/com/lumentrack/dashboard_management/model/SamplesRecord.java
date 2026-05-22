package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

public record SamplesRecord (
	Integer sampleId,
	Integer orderId,
	String sampleName,
	String samplePhotoUrl,
	String samplePhotoId,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate realDeliveryDate
) { }

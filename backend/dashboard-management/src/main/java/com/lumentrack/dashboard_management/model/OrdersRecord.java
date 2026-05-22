package com.lumentrack.dashboard_management.model;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

public record OrdersRecord (
	Integer orderId,
	Integer orderNumber,
	String orderName,
	Integer clientId,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd")
	LocalDate realDeliveryDate
) { }

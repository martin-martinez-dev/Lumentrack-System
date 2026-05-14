package com.lumentrack.dashboard_management.model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

public record OrdersRecord (
	Integer orderId,
	Integer orderNumber,
	String orderName,
	Integer clientId,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime estimatedDeliveryDate,
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	LocalDateTime realDeliveryDate
) { }

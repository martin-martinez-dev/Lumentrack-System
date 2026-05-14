package com.lumentrack.dashboard_management.model;

import java.util.List;

public record Dashboard (
	Integer sampleCount,
	Integer ordersCount,
	Integer tasksCount,
	List<SamplesRecord> samplesList,
	List<OrdersRecord> ordersList,
	List<TasksRecord> tasksList
) { }

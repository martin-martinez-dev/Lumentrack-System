package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.dashboard_management.model.Orders;
import com.lumentrack.dashboard_management.model.OrdersRecord;

@Mapper(componentModel = "spring")
public interface OrdersMapper {	
	OrdersRecord toRecord(Orders order);
	List<OrdersRecord> toRecordList(List<Orders> orders);
}

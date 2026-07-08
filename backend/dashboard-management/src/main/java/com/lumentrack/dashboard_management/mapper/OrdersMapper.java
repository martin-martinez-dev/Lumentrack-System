package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.commons.model.Orders; // Actualizado: Usar la entidad Orders de commons
import com.lumentrack.dashboard_management.model.OrdersRecord;
import com.lumentrack.dashboard_management.model.SamplesRecord; // Nueva importación, aunque no se usa directamente aquí, es para el record

@Mapper(componentModel = "spring", uses = {SamplesMapper.class}) // Añadido: uses = {SamplesMapper.class}
public interface OrdersMapper {	
	OrdersRecord toRecord(Orders order);
	List<OrdersRecord> toRecordList(List<Orders> orders);
}
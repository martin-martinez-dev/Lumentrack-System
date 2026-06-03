package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.commons.model.Samples; // Actualizado: Usar la entidad Samples de commons
import com.lumentrack.dashboard_management.model.SamplesRecord;
import com.lumentrack.dashboard_management.model.OrdersRecord; // Nueva importación, para el record
import com.lumentrack.dashboard_management.model.ComponentsRecord; // Nueva importación, para el record

@Mapper(componentModel = "spring", uses = {OrdersMapper.class, ComponentsMapper.class}) // Añadido: uses = {OrdersMapper.class, ComponentsMapper.class}
public interface SamplesMapper {
	SamplesRecord toRecord(Samples sample);
	List<SamplesRecord> toRecordList(List<Samples> samples);
}
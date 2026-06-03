package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.commons.model.Tasks; // Actualizado: Usar la entidad Tasks de commons
import com.lumentrack.dashboard_management.model.TasksRecord;
import com.lumentrack.dashboard_management.model.ComponentsRecord; // Nueva importación, para el record

@Mapper(componentModel = "spring", uses = {ComponentsMapper.class}) // Añadido: uses = {ComponentsMapper.class}
public interface TasksMapper {
	TasksRecord toRecord(Tasks task);
	List<TasksRecord> toRecordList(List<Tasks> tasks);
}
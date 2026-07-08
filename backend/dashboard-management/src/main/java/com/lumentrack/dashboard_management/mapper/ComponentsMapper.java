package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import com.lumentrack.commons.model.Components; // Usar la entidad Components de commons
import com.lumentrack.dashboard_management.model.ComponentsRecord;
import com.lumentrack.dashboard_management.model.TasksRecord; // Para la lista de tareas

@Mapper(componentModel = "spring", uses = {TasksMapper.class}) // Usar TasksMapper para la lista de tareas
public interface ComponentsMapper {

    @Mapping(source = "sample.sampleId", target = "sampleId")
    @Mapping(source = "sample.sampleName", target = "sampleName")
    ComponentsRecord toRecord(Components component);
    List<ComponentsRecord> toRecordList(List<Components> components);
}
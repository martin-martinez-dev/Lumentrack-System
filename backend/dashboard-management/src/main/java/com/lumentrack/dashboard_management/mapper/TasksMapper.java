package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping; // Nueva importación

import com.lumentrack.commons.model.Tasks; // Usar la entidad Tasks de commons
import com.lumentrack.dashboard_management.model.TasksRecord;
// import com.lumentrack.dashboard_management.model.ComponentsRecord; // Eliminado: Ya no se necesita ComponentsRecord completo

@Mapper(componentModel = "spring") // Modificado: Eliminado ComponentsMapper de 'uses'
public interface TasksMapper {

    @Mapping(source = "component.componentId", target = "componentId") // Mapear el ID del Component
    @Mapping(source = "component.componentName", target = "componentName") // Mapear el nombre del Component
    TasksRecord toRecord(Tasks task);

    List<TasksRecord> toRecordList(List<Tasks> tasks);
}
package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.dashboard_management.model.Tasks;
import com.lumentrack.dashboard_management.model.TasksRecord;

@Mapper(componentModel = "spring")
public interface TasksMapper {
	TasksRecord toRecord(Tasks task);
	List<TasksRecord> toRecordList(List<Tasks> tasks);
}

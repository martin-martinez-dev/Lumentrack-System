package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.lumentrack.dashboard_management.model.Samples;
import com.lumentrack.dashboard_management.model.SamplesRecord;

@Mapper(componentModel = "spring")
public interface SamplesMapper {
	SamplesRecord toRecord(Samples sample);
	List<SamplesRecord> toRecordList(List<Samples> samples);
}

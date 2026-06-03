package com.lumentrack.dashboard_management.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping; // Nueva importación

import com.lumentrack.commons.model.Samples; // Actualizado: Usar la entidad Samples de commons
import com.lumentrack.dashboard_management.model.SamplesRecord;
// import com.lumentrack.dashboard_management.model.OrdersRecord; // Eliminado: Ya no se necesita OrdersRecord completo
import com.lumentrack.dashboard_management.model.ComponentsRecord; // Nueva importación, para el record

@Mapper(componentModel = "spring", uses = {ComponentsMapper.class}) // Modificado: Eliminado OrdersMapper de 'uses'
public interface SamplesMapper {

    @Mapping(source = "order.orderId", target = "orderId") // Mapear el ID del Order
    @Mapping(source = "order.orderName", target = "orderName") // Mapear el nombre del Order
    SamplesRecord toRecord(Samples sample);

    List<SamplesRecord> toRecordList(List<Samples> samples);
}
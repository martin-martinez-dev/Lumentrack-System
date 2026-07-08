package com.lumentrack.dashboard_management.service;

import com.lumentrack.commons.model.Orders;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.commons.repository.OrdersRepository;
import com.lumentrack.commons.repository.SamplesRepository;
import com.lumentrack.commons.repository.TasksRepository;
import com.lumentrack.dashboard_management.mapper.OrdersMapper;
import com.lumentrack.dashboard_management.mapper.SamplesMapper;
import com.lumentrack.dashboard_management.mapper.TasksMapper;
import com.lumentrack.dashboard_management.model.Dashboard;
import com.lumentrack.dashboard_management.model.OrdersRecord;
import com.lumentrack.dashboard_management.model.SamplesRecord;
import com.lumentrack.dashboard_management.model.TasksRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class DashboardUserFilteredService {

    private final static Logger logger = LoggerFactory.getLogger(DashboardUserFilteredService.class);

    private final SamplesRepository samplesRepository;
    private final OrdersRepository ordersRepository;
    private final TasksRepository tasksRepository;
    private final OrdersMapper orderMapper;
    private final SamplesMapper samplesMapper;
    private final TasksMapper tasksMapper;

    @Autowired
    public DashboardUserFilteredService(SamplesRepository samplesRepository,
                                        OrdersRepository ordersRepository,
                                        TasksRepository tasksRepository,
                                        OrdersMapper orderMapper,
                                        SamplesMapper samplesMapper,
                                        TasksMapper tasksMapper) {
        this.samplesRepository = samplesRepository;
        this.ordersRepository = ordersRepository;
        this.tasksRepository = tasksRepository;
        this.orderMapper = orderMapper;
        this.samplesMapper = samplesMapper;
        this.tasksMapper = tasksMapper;
    }

    public Dashboard getDashboardDataForUser(Integer userId) {
        logger.info("Retrieving dashboard data for user with ID: {}", userId);

        Pageable limitQuery = PageRequest.of(0, 5); // Limitar a 5 elementos para las listas

        // Obtener Samples relacionados con el usuario
        List<Samples> userSamples = samplesRepository.findByComponentsUserIdWithOrderAndComponents(userId);
        logger.info("Found {} samples for user {}", userSamples.size(), userId);

        // Obtener Orders relacionados con el usuario
        List<Orders> userOrders = ordersRepository.findByComponentsUserIdWithDetails(userId);
        logger.info("Found {} orders for user {}", userOrders.size(), userId);

        // Obtener Tasks relacionados con el usuario
        List<Tasks> userTasks = tasksRepository.findByComponentsUserIdWithComponent(userId);
        logger.info("Found {} tasks for user {}", userTasks.size(), userId);

        // Mapear a Records para el Dashboard
        List<SamplesRecord> samplesRecordList = userSamples.stream()
                .limit(limitQuery.getPageSize()) // Aplicar el límite de la paginación
                .map(samplesMapper::toRecord)
                .collect(Collectors.toList());

        List<OrdersRecord> orderRecordList = userOrders.stream()
                .limit(limitQuery.getPageSize()) // Aplicar el límite de la paginación
                .map(orderMapper::toRecord)
                .collect(Collectors.toList());

        List<TasksRecord> tasksRecordList = userTasks.stream()
                .limit(limitQuery.getPageSize()) // Aplicar el límite de la paginación
                .map(tasksMapper::toRecord)
                .collect(Collectors.toList());

        // Contar los elementos totales filtrados por usuario
        int totalSamples = userSamples.size();
        int totalOrders = userOrders.size();
        int totalTasks = userTasks.size();

        return new Dashboard(
                totalSamples,
                totalOrders,
                totalTasks,
                samplesRecordList,
                orderRecordList,
                tasksRecordList
        );
    }
}
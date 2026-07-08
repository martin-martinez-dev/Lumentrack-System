package com.lumentrack.dashboard_management.service;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.lumentrack.dashboard_management.mapper.OrdersMapper;
import com.lumentrack.dashboard_management.mapper.SamplesMapper;
import com.lumentrack.dashboard_management.mapper.TasksMapper;
import com.lumentrack.dashboard_management.model.Dashboard;
import com.lumentrack.commons.model.Orders;
import com.lumentrack.dashboard_management.model.OrdersRecord;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.dashboard_management.model.SamplesRecord;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.dashboard_management.model.TasksRecord;
import com.lumentrack.commons.repository.OrdersRepository;
import com.lumentrack.commons.repository.SamplesRepository;
import com.lumentrack.commons.repository.TasksRepository;

@Service
public class DashboardService {

	private final static Logger logger = LoggerFactory.getLogger(DashboardService.class);
	
	private final SamplesRepository samplesRepository; // Hacerlo final
	private final OrdersRepository ordersRepository; // Hacerlo final
	private final TasksRepository tasksRepository; // Hacerlo final
	private final OrdersMapper orderMapper; // Hacerlo final
	private final SamplesMapper samplesMapper; // Hacerlo final
	private final TasksMapper tasksMapper; // Hacerlo final

    @Autowired // Inyección por constructor
    public DashboardService(SamplesRepository samplesRepository,
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
	
	public Dashboard getDashboardData() {
		
		logger.info("Retrieving the data for the dashboard page");
		
		logger.info("Getting the elements lists");
		
		Pageable limitQuery = PageRequest.of(0, 5);
		
		List<Samples> samplesList = samplesRepository.findAllByOrderByEstimatedDeliveryDateDesc(limitQuery);
		List<Orders> ordersList = ordersRepository.findAllByOrderByEstimatedDeliveryDateDesc(limitQuery);
		List<Tasks> tasksList = tasksRepository.findAllByOrderByTaskEstimatedDateDesc(limitQuery);
		
		logger.info("Service has found " + samplesList.size() + " samples");
		logger.info("Service has found " + ordersList.size() + " orders");
		logger.info("Service has found " + tasksList.size() + " tasks");
		
		List<SamplesRecord> samplesRecordList = (samplesList != null) ? samplesMapper.toRecordList(samplesList) : List.of();
	    List<OrdersRecord> orderRecordList = (ordersList != null) ? orderMapper.toRecordList(ordersList) : List.of();
	    List<TasksRecord> tasksRecordList = (tasksList != null) ? tasksMapper.toRecordList(tasksList) : List.of();
		
//		return new Dashboard(
//				((samplesList != null) ? samplesList.size() : 0),
//				((ordersList != null) ? ordersList.size() : 0),
//				((tasksList != null) ? tasksList.size() : 0),
//				samplesRecordList,
//				orderRecordList,
//				tasksRecordList
//			);
	    
	    return new Dashboard(
				(int) samplesRepository.count(),
				(int) ordersRepository.count(),
				(int) tasksRepository.count(),
				samplesRecordList,
				orderRecordList,
				tasksRecordList
			);
		
	}
	
}
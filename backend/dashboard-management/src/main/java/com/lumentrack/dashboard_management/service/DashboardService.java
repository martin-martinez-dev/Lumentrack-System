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
import com.lumentrack.dashboard_management.model.Orders;
import com.lumentrack.dashboard_management.model.OrdersRecord;
import com.lumentrack.dashboard_management.model.Samples;
import com.lumentrack.dashboard_management.model.SamplesRecord;
import com.lumentrack.dashboard_management.model.Tasks;
import com.lumentrack.dashboard_management.model.TasksRecord;
import com.lumentrack.dashboard_management.repository.OrdersRepository;
import com.lumentrack.dashboard_management.repository.SamplesRepository;
import com.lumentrack.dashboard_management.repository.TasksRepository;

@Service
public class DashboardService {

	private final static Logger logger = LoggerFactory.getLogger(DashboardService.class);
	
	@Autowired
	SamplesRepository samplesRepository;
	
	@Autowired
	OrdersRepository ordersRepository;
	
	@Autowired
	TasksRepository tasksRepository;
	
	@Autowired
	OrdersMapper orderMapper;
	
	@Autowired
	SamplesMapper samplesMapper;
	
	@Autowired
	TasksMapper tasksMapper;
	
	public Dashboard getDashboardData() {
		
		logger.info("Retrieving the data for the dashboard page");
		
		logger.info("Getting the elements lists");
		
		Pageable limitQuery = PageRequest.of(0, 5);
		
		List<Samples> samplesList = samplesRepository.findAllSortedByEstimatedDeliveryDate(limitQuery);
		List<Orders> ordersList = ordersRepository.findAllSortedByEstimatedDeliveryDate(limitQuery);
		List<Tasks> tasksList = tasksRepository.findAllSortedByTaskEstimatedDate(limitQuery);
		
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

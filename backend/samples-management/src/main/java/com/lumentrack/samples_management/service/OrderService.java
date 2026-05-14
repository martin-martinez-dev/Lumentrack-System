package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lumentrack.samples_management.model.Orders;
import com.lumentrack.samples_management.repository.OrdersRepository;

@Service
public class OrderService {
	
	private final static Logger logger = LoggerFactory.getLogger(OrderService.class);
	
	@Autowired
	private OrdersRepository repository;
	
	public Orders saveProject(Orders project) {
		logger.info( "Saving project: " + project.getOrderName() );
		return repository.save(project);
	}
	
	public List<Orders> getAllProjects() {
		logger.info("Retrieving all the Projects");
		return repository.findAll();
	}
	
	public Optional<Orders> getProjectById(Integer id) {
		logger.info("Retrieving information for id: " + id);
		return repository.findById(id);
	}
	
	public Orders updateProject(Orders updatedProject) {
		logger.info("Updating information for project: " + updatedProject.getOrderName());
		return repository.findById( updatedProject.getOrderId() ).map(projects -> {
			projects.setOrderName( updatedProject.getOrderName() );
			projects.setEstimatedDeliveryDate( updatedProject.getEstimatedDeliveryDate() );
			projects.setRealDeliveryDate( updatedProject.getRealDeliveryDate() );
			return repository.save(projects);
		}).orElseThrow( () -> new RuntimeException("Proyecto no encontrado") );
	}
	
	public void deleteProjectById(Integer id) {
		//Verifying that the project exists
		Orders project = repository.findById(id)
				.orElseThrow(() -> new RuntimeException("Proyecto no encontrado con id: " + id));
		
		logger.info( "Project with id: " + id + " has been found!" );
		logger.info( "Deleting information for project: " + project.getOrderName() );
		repository.deleteById(id);
	}
	
}

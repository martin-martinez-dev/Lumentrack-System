package com.lumentrack.samples_management.service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.commons.model.Orders;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.repository.OrdersRepository;
import com.lumentrack.commons.repository.SamplesRepository;

@Service
public class OrderService {
	
	private final static Logger logger = LoggerFactory.getLogger(OrderService.class);
	
	@Autowired
	private OrdersRepository repository;
	
	@Autowired
	private SamplesRepository sampleRepository; // Aunque ya no se usará directamente para findByOrderId, se mantiene por si hay otros usos.
	
	public Orders saveProject(Orders project) {
		logger.info( "Saving project: " + project.getOrderName() );
		return repository.save(project);
	}
	
	public List<Orders> getAllProjects() {
		logger.info("Retrieving all the Projects");
		return repository.findAll();
	}

	// Nuevo método para obtener órdenes por userId de sus componentes
	public List<Orders> getOrdersByUserId(Integer userId) {
		logger.info("Retrieving orders for userId: " + userId);
		return repository.findByComponentsUserId(userId);
	}
	
	public Optional<Orders> getProjectById(Integer id) {
		logger.info("Retrieving information for id: " + id);
		return repository.findById(id);
	}
	
	@Transactional
	public Orders updateProject(Orders updatedProject) {
		logger.info("Updating information for project: " + updatedProject.getOrderName());
		return repository.findById( updatedProject.getOrderId() ).map(projects -> {
			projects.setOrderName( updatedProject.getOrderName() );
			projects.setEstimatedDeliveryDate( updatedProject.getEstimatedDeliveryDate() );
			projects.setRealDeliveryDate( updatedProject.getRealDeliveryDate() );
			projects.setOrderNumber( updatedProject.getOrderNumber() );
			projects.setClientId( updatedProject.getClientId() );
			// Asegúrate de actualizar también la relación con Samples si es parte de la actualización
			// projects.setSamples(updatedProject.getSamples());
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
	
	public Orders getOrderDetails(Integer orderId) {
	    // 1. Buscamos la orden y lanzamos nuestra excepción personalizada de negocio
	    Orders order = repository.findById(orderId)
	            .orElseThrow(() -> new ResourceNotFoundException(
	                "El proyecto con ID " + orderId + " no existe."
	            ));
	    
	    // 2. Acceder directamente a la relación Samples
	    List<Samples> orderSamples = order.getSamples();
	    List<Samples> safeSamples = (orderSamples != null) ? orderSamples : Collections.emptyList();

	    // 3. Construimos el ViewModel con la certeza de que el objeto existe
	    return Orders.builder()
	            .orderId(order.getOrderId())
	            .orderNumber(order.getOrderNumber())
	            .orderName(order.getOrderName())
	            .clientId(order.getClientId())
	            .estimatedDeliveryDate(order.getEstimatedDeliveryDate())
	            .realDeliveryDate(order.getRealDeliveryDate())
	            .samples(safeSamples) // Usar la lista de muestras de la relación
	            .build();
	}
	
}
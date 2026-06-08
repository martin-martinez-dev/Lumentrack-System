package com.lumentrack.samples_management.service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

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
import com.lumentrack.samples_management.requestors.OrderRequest;
import com.lumentrack.samples_management.requestors.OrderDetailsResponse;
import com.lumentrack.samples_management.requestors.SampleDetailsResponse;

@Service
public class OrderService {
	
	private final static Logger logger = LoggerFactory.getLogger(OrderService.class);
	
	@Autowired
	private OrdersRepository repository;
	
	@Autowired
	private SamplesRepository sampleRepository;

	@Autowired
	private SampleService sampleService;
	
	@Transactional
	public Orders saveOrder(OrderRequest orderRequest) {
		logger.info( "Saving order: " + orderRequest.getOrderName() );

		Orders order = Orders.builder()
				.orderNumber(orderRequest.getOrderNumber())
				.orderName(orderRequest.getOrderName())
				.clientId(orderRequest.getClientId())
				.estimatedDeliveryDate(orderRequest.getEstimatedDeliveryDate())
				.realDeliveryDate(orderRequest.getRealDeliveryDate())
				.build();
		
		return repository.save(order);
	}
	
	public List<OrderDetailsResponse> getAllOrders() {
		logger.info("Retrieving all the Orders with Samples (eagerly fetched)");
		List<Orders> allOrders = repository.findAllWithSamples(); // Usar el nuevo método con JOIN FETCH
		
		// Mapear cada Order a un OrderDetailsResponse usando el nuevo método privado
		return allOrders.stream()
				.map(this::mapOrderToOrderDetailsResponse)
				.collect(Collectors.toList());
	}

	// Revertido a su estado original
	public List<Orders> getOrdersByUserId(Integer userId) {
		logger.info("Retrieving orders for userId: " + userId);
		return repository.findByComponentsUserId(userId);
	}

	// NUEVO: Método para obtener órdenes por userId con todos los detalles (DTOs)
	public List<OrderDetailsResponse> getOrdersDetailsByUserId(Integer userId) {
		logger.info("Retrieving orders for userId: " + userId + " with all details (eagerly fetched)");
		List<Orders> orders = repository.findByComponentsUserIdWithDetails(userId); // Usar el nuevo método con JOIN FETCH
		
		return orders.stream()
				.map(this::mapOrderToOrderDetailsResponse) // Mapear a DTOs
				.collect(Collectors.toList());
	}
	
	public Optional<Orders> getOrderById(Integer id) {
		logger.info("Retrieving information for id: " + id);
		return repository.findById(id);
	}
	
	@Transactional
	public Orders updateOrder(OrderRequest orderRequest) {
		logger.info("Updating information for order: " + orderRequest.getOrderName());
		return repository.findById( orderRequest.getOrderId() ).map(order -> {
			order.setOrderName( orderRequest.getOrderName() );
			order.setEstimatedDeliveryDate( orderRequest.getEstimatedDeliveryDate() );
			order.setRealDeliveryDate( orderRequest.getRealDeliveryDate() );
			order.setOrderNumber( orderRequest.getOrderNumber() );
			order.setClientId( orderRequest.getClientId() );
			return repository.save(order);
		}).orElseThrow( () -> new ResourceNotFoundException("Orden no encontrada con id: " + orderRequest.getOrderId()) );
	}
	
	public void deleteOrderById(Integer id) {
		Orders order = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con id: " + id));
		
		logger.info( "Order with id: " + id + " has been found!" );
		logger.info( "Deleting information for order: " + order.getOrderName() );
		repository.deleteById(id);
	}
	
	// Renombrado y modificado para obtener el DTO de una orden por su ID
	public OrderDetailsResponse getOrderDetailResponseById(Integer orderId) {
	    Orders order = repository.findById(orderId)
	            .orElseThrow(() -> new ResourceNotFoundException(
	                "La orden con ID " + orderId + " no existe."
	            ));
	    return mapOrderToOrderDetailsResponse(order);
	}

	// Nuevo método privado para mapear una entidad Orders a OrderDetailsResponse
	private OrderDetailsResponse mapOrderToOrderDetailsResponse(Orders order) {
	    List<Samples> orderSamples = order.getSamples();
	    
	    List<SampleDetailsResponse> safeSamples = (orderSamples != null) ?
	            orderSamples.stream()
	                    .map(sampleService::mapSampleToSampleDetailsResponse) // Usar el método de mapeo de SampleService
	                    .collect(Collectors.toList()) :
	            Collections.emptyList();

	    return OrderDetailsResponse.builder()
	            .orderId(order.getOrderId())
	            .orderNumber(order.getOrderNumber())
	            .orderName(order.getOrderName())
	            .clientId(order.getClientId())
	            .estimatedDeliveryDate(order.getEstimatedDeliveryDate())
	            .realDeliveryDate(order.getRealDeliveryDate())
	            .samples(safeSamples)
	            .build();
	}
	
}
package com.lumentrack.samples_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.commons.model.Orders;
import com.lumentrack.samples_management.service.OrderService;
import com.lumentrack.samples_management.requestors.OrderRequest;
import com.lumentrack.samples_management.requestors.OrderDetailsResponse;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {

	private final static Logger logger = LoggerFactory.getLogger(OrderController.class);

	private final OrderService service; // Hacerlo final

    @Autowired // Inyección por constructor
    public OrderController(OrderService service) {
        this.service = service;
    }

	@PostMapping("/save")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public ResponseEntity<Orders> saveOrder(@RequestBody OrderRequest orderRequest) {
		logger.info("Saving info for order: " + orderRequest.getOrderName());
		return new ResponseEntity<>(service.saveOrder(orderRequest), HttpStatus.CREATED);
	}

	@GetMapping("/list")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'PRODUCTION')")
	public List<OrderDetailsResponse> retrieveOrders() {
		logger.info("Getting the list of orders");
		return service.getAllOrders();
	}

	@GetMapping("/list/user/{userId}")
	@PreAuthorize("hasAnyAuthority('DESIGN')")
	public List<Orders> retrieveOrdersByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing orders for userId: " + userId);
		return service.getOrdersByUserId(userId);
	}

	// NUEVO: Endpoint para listar órdenes con detalles por userId
	@GetMapping("/list/details/user/{userId}")
	@PreAuthorize("hasAnyAuthority('DESIGN')")
	public List<OrderDetailsResponse> retrieveOrdersDetailsByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing order details for userId: " + userId);
		return service.getOrdersDetailsByUserId(userId);
	}

	@GetMapping("/search/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN', 'PRODUCTION')")
	public ResponseEntity<Orders> getOrderById(@PathVariable("id") Integer id){
		logger.info("Getting order information for id: " + id);
		return service.getOrderById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@PostMapping("/update")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public OrderDetailsResponse updateOrder(@RequestBody OrderRequest orderRequest) { // CAMBIADO: Tipo de retorno a OrderDetailsResponse
		logger.info("Updating information for order: " + orderRequest.getOrderName());
		return service.updateOrder(orderRequest);
	}

	@DeleteMapping("/delete/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteOrderById(@PathVariable("id") Integer id) {
		logger.info("Deleting info for id: " + id);
		service.deleteOrderById(id);
	}

	@GetMapping("/getOrderDetails/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN', 'PRODUCTION')")
	public OrderDetailsResponse getOrderDetails( @PathVariable("id") Integer id ) {
		logger.info("Retrieving the details for the order with Id: " + id);
		return service.getOrderDetailResponseById(id);
	}

}
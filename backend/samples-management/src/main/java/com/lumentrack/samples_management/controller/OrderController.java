package com.lumentrack.samples_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.samples_management.model.Orders;
import com.lumentrack.samples_management.service.OrderService;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {
	
	private final static Logger logger = LoggerFactory.getLogger(OrderController.class);
	
	@Autowired
	OrderService service;
	
	@PostMapping("/save")
	public ResponseEntity<Orders> saveProject(@RequestBody Orders project) {
		logger.info("Saving info for project: " + project.getOrderName());
		return new ResponseEntity<Orders>(service.saveProject(project), HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	public List<Orders> retrieveProjects() {
		logger.info("Getting the list of projects");
		return service.getAllProjects();
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Orders> getProjectById(@PathVariable("id") Integer id){
		logger.info("Getting project information for id: " + id);
		return service.getProjectById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Orders updateProject(@RequestBody Orders project) {
		logger.info("Updating information for project: " + project.getOrderName());
		return service.updateProject(project);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteProject(@PathVariable("id") Integer id) {
		logger.info("Deleting info for id: " + id);
		service.deleteProjectById(id);
	}
	
	@GetMapping("/getOrderDetails/{id}")
	public Orders getOrderDetails( @PathVariable("id") Integer id ) {
		logger.info("Retrieving the details for the order with Id: " + id);
		return service.getOrderDetails(id);
	}
	
}

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

import com.lumentrack.samples_management.model.Components;
import com.lumentrack.samples_management.service.ComponentService;

@RestController
@RequestMapping("/components")
@CrossOrigin(origins = "*")
public class ComponentsController {
	
	private final static Logger logger = LoggerFactory.getLogger(ComponentsController.class);
	
	@Autowired
	private ComponentService service;
	
	@PostMapping("/save")
	public ResponseEntity<Components> saveComponent(@RequestBody Components component) {
		logger.info("Start saving of component: " + component.getComponentName());
		return new ResponseEntity<Components>(service.saveComponent(component),HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	public List<Components> retrieveAll() {
		logger.info("Listing all the components");
		return service.getAllComponent();
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Components> searchComponentById(@PathVariable("id") Integer id) {
		logger.info("Search component by id: " + id);
		return service.getComponentById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Components updateComponent(@RequestBody Components component) {
		logger.info("Updating info for component: " + component.getComponentName());
		return service.updateComponent(component);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteComponent(@PathVariable("id") Integer id) {
		logger.info("Deleting info for component id: " + id);
		service.deleteComponent(id);
	}
	
	@GetMapping("/getComponentDetails/{id}")
	public Components getComponentDetails( @PathVariable("id") Integer id ) {
		logger.info("Getting the details for the component id " + id);
		return service.getComponentsDetails(id);
	}
	
}

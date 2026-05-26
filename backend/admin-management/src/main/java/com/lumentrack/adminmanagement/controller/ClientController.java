package com.lumentrack.adminmanagement.controller;

import com.lumentrack.adminmanagement.model.Clients;
import com.lumentrack.adminmanagement.service.ClientsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/clients")
@CrossOrigin(origins = "*")
public class ClientController {
	
	private final static Logger logger = LoggerFactory.getLogger(ClientController.class);
	
	@Autowired
	private ClientsService service;
	
	@PostMapping("/save")
	public ResponseEntity<Clients> saveClient(@RequestBody Clients client) {
		logger.info("Start saving process for " + client.getClientName());
		return new ResponseEntity<Clients>(service.saveClient(client), HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	public List<Clients> retrieveAllClients() {
		logger.info("Retrieving the client list");
		return service.getAllClients();
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Clients> searchClientById(@PathVariable("id") Integer id) {
		logger.info("Search Client by Id: " + id);
		return service.getClientById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Clients updateClient(@RequestBody Clients client) {
		logger.info("Update for Client:" + client.getClientName());
		return service.updateClient(client);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteClient(@PathVariable("id") Integer id) {
		logger.info("Delete client for id: " + id);
		service.deleteClient(id);
	}
	
}

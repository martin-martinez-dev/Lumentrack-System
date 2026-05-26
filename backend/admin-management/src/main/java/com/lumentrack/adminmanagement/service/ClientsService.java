package com.lumentrack.adminmanagement.service;

import com.lumentrack.adminmanagement.model.Clients;
import com.lumentrack.adminmanagement.repository.ClientsRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class ClientsService {
	
	private final static Logger logger = LoggerFactory.getLogger(ClientsService.class);
	
	@Autowired
	private ClientsRepository repository;
	
	public Clients saveClient ( Clients client ) {
		logger.info( "Saving client on service: " + client.getClientName() );
		
		return repository.save(client);
	}
	
	public List<Clients> getAllClients() {
		logger.info( "Getting all the clients" );
		
		return repository.findAll();
	}
	
	public Optional<Clients> getClientById(Integer id) {
		logger.info( "Get a single client by id: " + id );
		
		return repository.findById(id);
	}
	
	@Transactional
	public Clients updateClient(Clients updatedClient) {
		logger.info( "Updating information for the client: " + updatedClient.getClientName() );
		return repository.findById( updatedClient.getClientId() ).map( clients -> {
			clients.setClientName( updatedClient.getClientName() );
			clients.setCompanyName( updatedClient.getCompanyName() );
			clients.setClientContactName( updatedClient.getClientContactName() );
			clients.setClientPhoneNumber( updatedClient.getClientPhoneNumber() );
			clients.setClientMail( updatedClient.getClientMail() );
			clients.setUlaLightEmployee( updatedClient.getUlaLightEmployee() );
			return repository.save(clients);
		}).orElseThrow( () -> new RuntimeException("Cliente no encontrado") );
	}
	
	public void deleteClient(Integer id) {
		// Verifying client exists
		Clients client = repository.findById(id).orElseThrow(() -> new RuntimeException("Cliente no encontrado con id: " + id));
		
		logger.info( "Client with id: " + id + " has been found!" );
		logger.info( "Deleting information for the client: " + client.getClientName() );
		
		repository.deleteById(client.getClientId());
	}
	
}

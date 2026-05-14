package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lumentrack.samples_management.model.Components;
import com.lumentrack.samples_management.repository.ComponentsRepository;

@Service
public class ComponentService {
	
	private final static Logger logger = LoggerFactory.getLogger(ComponentService.class);
	
	@Autowired
	private ComponentsRepository repository;
	
	public Components saveComponent(Components component) {
		logger.info( "Saving information for component: " + component.getComponentName() );
		
		return repository.save(component);
	}
	
	public List<Components> getAllComponent() {
		logger.info("Retrieving all the components");
		return repository.findAll();
	}
	
	public Optional<Components> getComponentById(Integer id) {
		logger.info("Retrieving component with id: " + id);
		return repository.findById(id);
	}
	
	public Components updateComponent(Components component) {
		logger.info("Updating information for component: " + component.getComponentName());
		return repository.findById( component.getComponentId() ).map( components -> {
			components.setComponentName( component.getComponentName() );
			components.setComponentType( component.getComponentType() );
			components.setComponentDescription( component.getComponentDescription() );
			components.setIsExternal( component.getIsExternal() );
			components.setDeliveryDate( component.getDeliveryDate() );
			components.setMaterialId( component.getMaterialId() );
			return repository.save(components);
		}).orElseThrow( () -> new RuntimeException("Componente no encontrado") );
	}
	
	public void deleteComponent(Integer id) {
		// Verify that component exists
		Components component = repository.findById(id)
				.orElseThrow(() -> new RuntimeException("Componente no encontrado con id: " + id));
		
		logger.info("Component with id: " + id + " has been found!!!");
		logger.info("Deleting information for component " + component.getComponentName());
		repository.deleteById(component.getComponentId());
	}
	
}

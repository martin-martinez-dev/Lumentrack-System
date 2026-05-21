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
import com.lumentrack.samples_management.model.Components;
import com.lumentrack.samples_management.model.Materials;
import com.lumentrack.samples_management.model.Samples;
import com.lumentrack.samples_management.model.Tasks;
import com.lumentrack.samples_management.repository.ComponentsRepository;
import com.lumentrack.samples_management.repository.MaterialsRepository;
import com.lumentrack.samples_management.repository.SamplesRepository;
import com.lumentrack.samples_management.repository.TasksRepository;

@Service
public class ComponentService {
	
	private final static Logger logger = LoggerFactory.getLogger(ComponentService.class);
	
	@Autowired
	private ComponentsRepository repository;
	
	@Autowired
	private SamplesRepository sampleRepository;
	
	@Autowired
	private TasksRepository taskRepository;
	
	@Autowired
	private MaterialsRepository materialRepository;
	
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
	
	@Transactional
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
	
	public Components getComponentsDetails(Integer id) {
		logger.info("Retrieving details for component id " + id);
		Components component = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(
                "Componente con id " + id + " no existe."
            ));
		
		Optional<Samples> sample = sampleRepository.findById( component.getSampleId() );
		
		Optional<Materials> material = materialRepository.findById( component.getMaterialId() );
		
		List<Tasks> taskList = taskRepository.findByComponentId(id);
		List<Tasks> safeTasks = ( taskList != null ) ? taskList : Collections.emptyList();
		
		return Components.builder()
				.componentId( component.getComponentId() )
				.sampleId( component.getSampleId() )
				.sampleName( sample.get().getSampleName() )
				.componentName( component.getComponentName() )
				.componentType( component.getComponentType() )
				.componentDescription( component.getComponentDescription() )
				.componentPhotoUrl( component.getComponentPhotoUrl() )
				.componentPhotoId( component.getComponentPhotoId() )
				.isExternal( component.getIsExternal() )
				.deliveryDate( component.getDeliveryDate() )
				.materialId( component.getMaterialId() )
				.materialName( material.get().getMaterialName() )
				.statusResume( component.getStatusResume() )
				.ulaLightEmployee( component.getUlaLightEmployee() )
				.taskList( safeTasks )
				.build();
	}
	
}

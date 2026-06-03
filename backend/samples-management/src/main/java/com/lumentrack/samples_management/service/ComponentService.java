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
import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Materials;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.commons.repository.ComponentsRepository;
import com.lumentrack.commons.repository.MaterialsRepository;
import com.lumentrack.commons.repository.SamplesRepository;
import com.lumentrack.commons.repository.TasksRepository;

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
	
	// Nuevo método para obtener componentes por userId
	public List<Components> getComponentsByUserId(Integer userId) {
		logger.info("Retrieving components for userId: " + userId);
		return repository.findByUserId(userId);
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
			// Asegúrate de actualizar también el userId si es parte de la actualización
			components.setUserId(component.getUserId()); 
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
		
		// Aquí deberías usar la relación JPA 'sample' en lugar de 'sampleId'
		// Optional<Samples> sample = sampleRepository.findById( component.getSampleId() );
		// Asumiendo que la relación @ManyToOne 'sample' ya está cargada o se carga lazy
		Samples sample = component.getSample(); // Acceder directamente a la relación
		
		Optional<Materials> material = materialRepository.findById( component.getMaterialId() );
		
		// Aquí deberías usar la relación JPA 'tasks' en lugar de 'findByComponentId'
		// List<Tasks> taskList = taskRepository.findByComponentId(id);
		List<Tasks> taskList = component.getTasks(); // Acceder directamente a la relación
		List<Tasks> safeTasks = ( taskList != null ) ? taskList : Collections.emptyList();
		
		return Components.builder()
				.componentId( component.getComponentId() )
				// .sampleId( component.getSampleId() ) // Ya no es necesario si usas la relación 'sample'
				.sample(sample) // Usar la entidad completa
				//.sampleName( sample != null ? sample.getSampleName() : null ) // Acceder al nombre a través de la relación
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
				.userId(component.getUserId()) // Incluir el nuevo userId
				.tasks( safeTasks ) // Usar la lista de tareas de la relación
				.build();
	}
	
}
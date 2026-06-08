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
import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Materials;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.commons.repository.ComponentsRepository;
import com.lumentrack.commons.repository.MaterialsRepository;
import com.lumentrack.commons.repository.SamplesRepository;
import com.lumentrack.commons.repository.TasksRepository;
import com.lumentrack.samples_management.requestors.ComponentRequest;
import com.lumentrack.samples_management.requestors.ComponentDetailsResponse;
import com.lumentrack.samples_management.requestors.TaskDetailsResponse;

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
	
	@Transactional
	public Components saveComponent(ComponentRequest componentRequest) {
		logger.info( "Saving information for component: " + componentRequest.getComponentName() );
		
		Samples sample = sampleRepository.findById(componentRequest.getSampleId())
				.orElseThrow(() -> new ResourceNotFoundException("Muestra no encontrada con id: " + componentRequest.getSampleId()));
		
		Components component = Components.builder()
				.sample(sample)
				.componentName(componentRequest.getComponentName())
				.componentType(componentRequest.getComponentType())
				.componentDescription(componentRequest.getComponentDescription())
				.componentPhotoUrl(componentRequest.getComponentPhotoUrl())
				.componentPhotoId(componentRequest.getComponentPhotoId())
				.isExternal(componentRequest.getIsExternal())
				.deliveryDate(componentRequest.getDeliveryDate())
				.materialId(componentRequest.getMaterialId())
				.statusResume(componentRequest.getStatusResume())
				.ulaLightEmployee(componentRequest.getUlaLightEmployee())
				.userId(componentRequest.getUserId())
				.build();
		
		return repository.save(component);
	}
	
	// Revertido a su estado original
	public List<Components> getAllComponent() {
		logger.info("Retrieving all the components");
		return repository.findAll();
	}
	
	public List<Components> getComponentsByUserId(Integer userId) {
		logger.info("Retrieving components for userId: " + userId);
		return repository.findByUserId(userId);
	}
	
	public Optional<Components> getComponentById(Integer id) {
		logger.info("Retrieving component with id: " + id);
		return repository.findById(id);
	}
	
	@Transactional
	public Components updateComponent(ComponentRequest componentRequest) {
		logger.info("Updating information for component: " + componentRequest.getComponentName());
		return repository.findById( componentRequest.getComponentId() ).map( component -> {
			component.setComponentName( componentRequest.getComponentName() );
			component.setComponentType( componentRequest.getComponentType() );
			component.setComponentDescription( componentRequest.getComponentDescription() );
			component.setIsExternal( componentRequest.getIsExternal() );
			component.setDeliveryDate( componentRequest.getDeliveryDate() );
			component.setMaterialId( componentRequest.getMaterialId() );
			component.setStatusResume(componentRequest.getStatusResume());
			component.setUlaLightEmployee(componentRequest.getUlaLightEmployee());
			component.setUserId(componentRequest.getUserId()); 
			
			if (!component.getSample().getSampleId().equals(componentRequest.getSampleId())) {
				Samples newSample = sampleRepository.findById(componentRequest.getSampleId())
						.orElseThrow(() -> new ResourceNotFoundException("Muestra no encontrada con id: " + componentRequest.getSampleId()));
				component.setSample(newSample);
			}
			
			return repository.save(component);
		}).orElseThrow( () -> new ResourceNotFoundException("Componente no encontrado con id: " + componentRequest.getComponentId()) );
	}
	
	public void deleteComponent(Integer id) {
		Components component = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Componente no encontrado con id: " + id));
		
		logger.info("Component with id: " + id + " has been found!!!");
		logger.info("Deleting information for component " + component.getComponentName());
		repository.deleteById(component.getComponentId());
	}
	
	// Revertido a su estado original
	public ComponentDetailsResponse getComponentsDetails(Integer id) {
		logger.info("Retrieving details for component id " + id);
		Components component = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(
                "Componente con id " + id + " no existe."
            ));
		
		Samples sample = component.getSample(); 
		Optional<Materials> material = materialRepository.findById( component.getMaterialId() );
		List<Tasks> taskList = component.getTasks(); 
		
		List<TaskDetailsResponse> safeTasks = ( taskList != null ) ? 
				taskList.stream().map(task -> TaskDetailsResponse.builder()
						.taskId(task.getTaskId())
						.taskName(task.getTaskName())
						.taskDescription(task.getTaskDescription())
						.taskPhotoUrl(task.getTaskPhotoUrl())
						.taskPhotoId(task.getTaskPhotoId())
						.taskEstimatedDate(task.getTaskEstimatedDate())
						.taskRealDateTime(task.getTaskRealDateTime())
						.componentId(component.getComponentId())
						.componentName(component.getComponentName())
						.build())
				.collect(Collectors.toList()) : Collections.emptyList();
		
		return ComponentDetailsResponse.builder()
				.componentId( component.getComponentId() )
				.sampleId(sample != null ? sample.getSampleId() : null)
				.sampleName(sample != null ? sample.getSampleName() : null)
				.componentName( component.getComponentName() )
				.componentType( component.getComponentType() )
				.componentDescription( component.getComponentDescription() )
				.componentPhotoUrl( component.getComponentPhotoUrl() )
				.componentPhotoId( component.getComponentPhotoId() )
				.isExternal( component.getIsExternal() )
				.deliveryDate( component.getDeliveryDate() )
				.materialId( component.getMaterialId() )
				.materialName( material.map(Materials::getMaterialName).orElse(null) )
				.statusResume( component.getStatusResume() )
				.ulaLightEmployee( component.getUlaLightEmployee() )
				.userId(component.getUserId())
				.tasks( safeTasks )
				.build();
	}

	// NUEVO: Método para obtener todos los componentes con detalles (eagerly fetched)
	public List<ComponentDetailsResponse> getAllComponentDetails() {
		logger.info("Retrieving all Component Details (eagerly fetched)");
		List<Components> allComponents = repository.findAllWithTasksAndUser();
		return allComponents.stream()
				.map(this::mapComponentToComponentDetailsResponse)
				.collect(Collectors.toList());
	}

	// NUEVO: Método para obtener los detalles de un componente por ID (eagerly fetched)
	public ComponentDetailsResponse getComponentDetailsById(Integer id) {
		logger.info("Retrieving details for component id " + id + " (eagerly fetched)");
		Components component = repository.findByIdWithTasksAndUser(id).orElseThrow(() -> new ResourceNotFoundException(
                "Componente con id " + id + " no existe."
            ));
		return mapComponentToComponentDetailsResponse(component);
	}

	// Método público para mapear una entidad Components a ComponentDetailsResponse
	public ComponentDetailsResponse mapComponentToComponentDetailsResponse(Components component) {
		Samples sample = component.getSample(); 
		Optional<Materials> material = materialRepository.findById( component.getMaterialId() );
		List<Tasks> taskList = component.getTasks(); 
		
		List<TaskDetailsResponse> safeTasks = ( taskList != null ) ? 
				taskList.stream().map(task -> TaskDetailsResponse.builder()
						.taskId(task.getTaskId())
						.taskName(task.getTaskName())
						.taskDescription(task.getTaskDescription())
						.taskPhotoUrl(task.getTaskPhotoUrl())
						.taskPhotoId(task.getTaskPhotoId())
						.taskEstimatedDate(task.getTaskEstimatedDate())
						.taskRealDateTime(task.getTaskRealDateTime())
						.componentId(component.getComponentId())
						.componentName(component.getComponentName())
						.build())
				.collect(Collectors.toList()) : Collections.emptyList();
		
		return ComponentDetailsResponse.builder()
				.componentId( component.getComponentId() )
				.sampleId(sample != null ? sample.getSampleId() : null)
				.sampleName(sample != null ? sample.getSampleName() : null)
				.componentName( component.getComponentName() )
				.componentType( component.getComponentType() )
				.componentDescription( component.getComponentDescription() )
				.componentPhotoUrl( component.getComponentPhotoUrl() )
				.componentPhotoId( component.getComponentPhotoId() )
				.isExternal( component.getIsExternal() )
				.deliveryDate( component.getDeliveryDate() )
				.materialId( component.getMaterialId() )
				.materialName( material.map(Materials::getMaterialName).orElse(null) )
				.statusResume( component.getStatusResume() )
				.ulaLightEmployee( component.getUlaLightEmployee() )
				.userId(component.getUserId())
				.tasks( safeTasks )
				.build();
	}
	
}
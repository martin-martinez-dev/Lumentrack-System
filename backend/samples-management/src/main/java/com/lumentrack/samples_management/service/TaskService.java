package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.commons.repository.ComponentsRepository;
import com.lumentrack.commons.repository.TasksRepository;
import com.lumentrack.samples_management.requestors.TaskRequest; // Nueva importación
import com.lumentrack.samples_management.requestors.TaskDetailsResponse; // Nueva importación

@Service
public class TaskService {
	
	private final static Logger logger = LoggerFactory.getLogger(TaskService.class);
	
	private final TasksRepository repository; // Hacerlo final
	private final ComponentsRepository componentRepository; // Hacerlo final

    @Autowired // Inyección por constructor
    public TaskService(TasksRepository repository, ComponentsRepository componentRepository) {
        this.repository = repository;
        this.componentRepository = componentRepository;
    }
	
	@Transactional
	public Tasks saveTask(TaskRequest taskRequest) { // Modificado para aceptar TaskRequest
		logger.info("Saving for task: " + taskRequest.getTaskName() );
		
		// Buscar la entidad Components
		Components component = componentRepository.findById(taskRequest.getComponentId())
				.orElseThrow(() -> new ResourceNotFoundException("Componente no encontrado con id: " + taskRequest.getComponentId()));
		
		Tasks task = Tasks.builder()
				.taskName(taskRequest.getTaskName())
				.taskDescription(taskRequest.getTaskDescription())
				.component(component) // Establecer la entidad Components
				.taskPhotoUrl(taskRequest.getTaskPhotoUrl())
				.taskPhotoId(taskRequest.getTaskPhotoId())
				.taskEstimatedDate(taskRequest.getTaskEstimatedDate())
				.taskRealDateTime(taskRequest.getTaskRealDateTime())
				.build();
		
		return repository.save(task);
	}
	
	public List<Tasks> getAllTasks() {
		logger.info("Getting all tasks");
		return repository.findAll();
	}

	// Nuevo método para obtener tareas por userId de sus componentes
	public List<Tasks> getTasksByUserId(Integer userId) {
		logger.info("Retrieving tasks for userId: " + userId);
		return repository.findByComponentsUserIdWithComponent(userId); // CAMBIADO: Nombre del método
	}
	
	public Optional<Tasks> getTaskById(Integer id) {
		logger.info("Get taks by id: " + id);
		return repository.findById(id);
	}

	@Transactional
	public TaskDetailsResponse updateTaks(TaskRequest taskRequest) { // Modificado para devolver TaskDetailsResponse
		logger.info("Updating the task: " + taskRequest.getTaskName());
		
		Tasks updatedTask = repository.findById( taskRequest.getTaskId() ).map(task -> {
			task.setTaskName(taskRequest.getTaskName()); // Actualizar nombre
			task.setTaskDescription( taskRequest.getTaskDescription() );
			task.setTaskPhotoUrl(taskRequest.getTaskPhotoUrl());
			task.setTaskPhotoId(taskRequest.getTaskPhotoId());
			task.setTaskEstimatedDate(taskRequest.getTaskEstimatedDate());
			task.setTaskRealDateTime( taskRequest.getTaskRealDateTime() );
			
			// Si el componentId cambia, buscar y establecer el nuevo Component
			if (!task.getComponent().getComponentId().equals(taskRequest.getComponentId())) {
				Components newComponent = componentRepository.findById(taskRequest.getComponentId())
						.orElseThrow(() -> new ResourceNotFoundException("Componente no encontrado con id: " + taskRequest.getComponentId()));
				task.setComponent(newComponent);
			}
			
			return repository.save(task);
		}).orElseThrow( () -> new ResourceNotFoundException("Tarea no encontrada con id: " + taskRequest.getTaskId()) );

		// Mapear la entidad actualizada a un DTO de respuesta
		return mapTaskToTaskDetailsResponse(updatedTask);
	}
	
	public void deleteTasks(Integer id) {
		//Verify if the task exists
		Tasks task = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Tarea no encontrada con id: " + id));
		
		logger.info( "Task with id: " + id + " has been found!" );
		logger.info( "Deleting information for task: " + task.getTaskName() );
		repository.deleteById( task.getTaskId() );
	}
	
	public TaskDetailsResponse getTaskDetails( Integer id ) { // Modificado para devolver TaskDetailsResponse
		logger.info("Retrieving the information for task with id " + id);
		
		Tasks task = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(
                "La tarea con id " + id + " no existe."
            ));
		
		// Acceder directamente a la relación Component
		Components component = task.getComponent();
		
		return TaskDetailsResponse.builder() // Usar el builder del DTO de respuesta
				.taskId( task.getTaskId() )
				.taskName( task.getTaskName())
				.taskDescription( task.getTaskDescription() )
				.componentId(component != null ? component.getComponentId() : null) // Mapear ID del componente
				.componentName(component != null ? component.getComponentName() : null) // Mapear nombre del componente
				.taskPhotoUrl( task.getTaskPhotoUrl() )
				.taskPhotoId( task.getTaskPhotoId() )
				.taskEstimatedDate( task.getTaskEstimatedDate() )
				.taskRealDateTime( task.getTaskRealDateTime() )
				.build();
	}

	// Método privado para mapear una entidad Tasks a TaskDetailsResponse
	private TaskDetailsResponse mapTaskToTaskDetailsResponse(Tasks task) {
		Components component = task.getComponent();
		return TaskDetailsResponse.builder()
				.taskId(task.getTaskId())
				.taskName(task.getTaskName())
				.taskDescription(task.getTaskDescription())
				.componentId(component != null ? component.getComponentId() : null)
				.componentName(component != null ? component.getComponentName() : null)
				.taskPhotoUrl(task.getTaskPhotoUrl())
				.taskPhotoId(task.getTaskPhotoId())
				.taskEstimatedDate(task.getTaskEstimatedDate())
				.taskRealDateTime(task.getTaskRealDateTime()) // CORREGIDO: Usar getTaskRealDateTime()
				.build();
	}
}
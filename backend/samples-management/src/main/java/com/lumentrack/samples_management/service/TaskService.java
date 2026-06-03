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

@Service
public class TaskService {
	
	private final static Logger logger = LoggerFactory.getLogger(TaskService.class);
	
	@Autowired
	private TasksRepository repository;
	
	@Autowired
	private ComponentsRepository componentRepository; // Se mantiene por si hay otros usos, aunque getTaskDetails ya no lo usará directamente.
	
	public Tasks saveTask(Tasks task) {
		logger.info("Saving for task: " + task.getTaskName() );
		return repository.save(task);
	}
	
	public List<Tasks> getAllTasks() {
		logger.info("Getting all tasks");
		return repository.findAll();
	}

	// Nuevo método para obtener tareas por userId de sus componentes
	public List<Tasks> getTasksByUserId(Integer userId) {
		logger.info("Retrieving tasks for userId: " + userId);
		return repository.findByComponentsUserId(userId);
	}
	
	public Optional<Tasks> getTaskById(Integer id) {
		logger.info("Get taks by id: " + id);
		return repository.findById(id);
	}

	@Transactional
	public Tasks updateTaks(Tasks task) {
		logger.info("Updating the task: " + task.getTaskName());
		
		return repository.findById( task.getTaskId() ).map(tasks -> {
			tasks.setTaskDescription( task.getTaskDescription() );
			tasks.setTaskRealDateTime( tasks.getTaskRealDateTime() );
			// Asegúrate de actualizar también la relación con Component si es parte de la actualización
			// tasks.setComponent(task.getComponent());
			return tasks;
		}).orElseThrow( () -> new RuntimeException("Tarea no encontrada") );
	}
	
	public void deleteTasks(Integer id) {
		//Verify if the task exists
		Tasks task = repository.findById(id)
				.orElseThrow(() -> new RuntimeException("Tarea no encontrada con id: " + id));
		
		logger.info( "Task with id: " + id + " has been found!" );
		logger.info( "Deleting information for task: " + task.getTaskName() );
		repository.deleteById( task.getTaskId() );
	}
	
	public Tasks getTaskDetails( Integer id ) {
		logger.info("Retrieving the information for task with id " + id);
		
		Tasks task = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(
                "La tarea con id " + id + " no existe."
            ));
		
		// Acceder directamente a la relación Component
		Components component = task.getComponent();
		
		return Tasks.builder()
				.taskId( task.getTaskId() )
				.taskName( task.getTaskName())
				.taskDescription( task.getTaskDescription() )
				// .componentId( task.getComponentId() ) // Ya no es necesario si usas la relación 'component'
				.component(component) // Usar la entidad completa
				//.componentName( component != null ? component.getComponentName() : null ) // Acceder al nombre a través de la relación
				.taskPhotoUrl( task.getTaskPhotoUrl() )
				.taskPhotoId( task.getTaskPhotoId() )
				.taskEstimatedDate( task.getTaskEstimatedDate() )
				.taskRealDateTime( task.getTaskRealDateTime() )
				.build();
	}
}
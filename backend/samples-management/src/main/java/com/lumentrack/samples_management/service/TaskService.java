package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.samples_management.model.Components;
import com.lumentrack.samples_management.model.Tasks;
import com.lumentrack.samples_management.repository.ComponentsRepository;
import com.lumentrack.samples_management.repository.TasksRepository;

@Service
public class TaskService {
	
	private final static Logger logger = LoggerFactory.getLogger(TaskService.class);
	
	@Autowired
	private TasksRepository repository;
	
	@Autowired
	private ComponentsRepository componentRepository;
	
	public Tasks saveTask(Tasks task) {
		logger.info("Saving for task: " + task.getTaskName() );
		return repository.save(task);
	}
	
	public List<Tasks> getAllTasks() {
		logger.info("Getting all tasks");
		return repository.findAll();
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
		
		Optional<Components> component = componentRepository.findById( task.getComponentId() );
		
		return Tasks.builder()
				.taskId( task.getTaskId() )
				.taskName( task.getTaskName())
				.taskDescription( task.getTaskDescription() )
				.componentId( task.getComponentId() )
				.componentName( component.get().getComponentName() )
				.taskPhotoUrl( task.getTaskPhotoUrl() )
				.taskPhotoId( task.getTaskPhotoId() )
				.taskEstimatedDate( task.getTaskEstimatedDate() )
				.taskRealDateTime( task.getTaskRealDateTime() )
				.build();
	}
}

package com.lumentrack.samples_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.commons.model.Tasks;
import com.lumentrack.samples_management.service.TaskService;
import com.lumentrack.samples_management.requestors.TaskRequest; // Nueva importación
import com.lumentrack.samples_management.requestors.TaskDetailsResponse; // Nueva importación

@RestController
@RequestMapping("/tasks")
@CrossOrigin(origins = "*")
public class TaskController {
	
	private final static Logger logger = LoggerFactory.getLogger(TaskController.class);
	
	private final TaskService service; // Hacerlo final

    @Autowired // Inyección por constructor
    public TaskController(TaskService service) {
        this.service = service;
    }
	
	@PostMapping("/save")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')") // CAMBIADO
	public ResponseEntity<Tasks> saveTask(@RequestBody TaskRequest taskRequest) { // Modificado para aceptar TaskRequest
		logger.info("Saving info for task: " + taskRequest.getTaskName());
		return new ResponseEntity<>(service.saveTask(taskRequest), HttpStatus.CREATED); // Pasar el request al servicio
	}
	
	@GetMapping("/list")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')") // CAMBIADO
	public List<Tasks> retrieveAllTasks() {
		logger.info("Getting information of all tasks");
		return service.getAllTasks();
	}

	// Nuevo endpoint para listar tareas por userId
	@GetMapping("/list/user/{userId}")
	@PreAuthorize("hasAnyAuthority('DESIGN')") // CAMBIADO
	public List<Tasks> retrieveTasksByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing tasks for userId: " + userId);
		return service.getTasksByUserId(userId);
	}
	
	@GetMapping("/search/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')") // CAMBIADO
	public ResponseEntity<Tasks> searchTaskById(@PathVariable("id") Integer id) {
		logger.info("Getting info for id: " + id);
		return service.getTaskById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')") // CAMBIADO
	public TaskDetailsResponse updateTask(@RequestBody TaskRequest taskRequest) { // CAMBIADO: Tipo de retorno a TaskDetailsResponse
		logger.info("Updating info for task: " + taskRequest.getTaskName());
		return service.updateTaks(taskRequest); // Pasar el request al servicio
	}
	
	@DeleteMapping("/delete/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')") // CAMBIADO
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteTask(@PathVariable("id") Integer id) {
		logger.info("Deleting info for id: " + id);
		service.deleteTasks(id);
	}
	
	@GetMapping("/getTasksDetails/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')") // CAMBIADO
	public TaskDetailsResponse getTasksDetails( @PathVariable("id") Integer id ) { // Modificado para devolver TaskDetailsResponse
		logger.info("Getting task details for id " + id);
		return service.getTaskDetails(id);
	}
	
}
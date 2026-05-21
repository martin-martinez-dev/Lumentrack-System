package com.lumentrack.samples_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.samples_management.model.Tasks;
import com.lumentrack.samples_management.service.TaskService;

@RestController
@RequestMapping("/tasks")
@CrossOrigin(origins = "*")
public class TaskController {
	
	private final static Logger logger = LoggerFactory.getLogger(TaskController.class);
	
	@Autowired
	private TaskService service;
	
	@PostMapping("/save")
	public ResponseEntity<Tasks> saveTask(@RequestBody Tasks task) {
		logger.info("Saving info for task: " + task.getTaskName());
		return new ResponseEntity<Tasks>(service.saveTask(task), HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	public List<Tasks> retrieveAllTasks() {
		logger.info("Getting information of all tasks");
		return service.getAllTasks();
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Tasks> searchTaskById(@PathVariable("id") Integer id) {
		logger.info("Getting info for id: " + id);
		return service.getTaskById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Tasks updateTask(@RequestBody Tasks task) {
		logger.info("Updating info for task: " + task.getTaskName());
		return service.updateTaks(task);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteTask(@PathVariable("id") Integer id) {
		logger.info("Deleting info for id: " + id);
		service.deleteTasks(id);
	}
	
	@GetMapping("/getTasksDetails/{id}")
	public Tasks getTasksDetails( @PathVariable("id") Integer id ) {
		logger.info("Getting task details for id " + id);
		return service.getTaskDetails(id);
	}
	
}

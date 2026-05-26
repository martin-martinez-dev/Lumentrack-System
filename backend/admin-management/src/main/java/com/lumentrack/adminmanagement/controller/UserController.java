package com.lumentrack.adminmanagement.controller;

import com.lumentrack.adminmanagement.model.Users;
import com.lumentrack.adminmanagement.service.UsersService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*")
public class UserController {
	
	private final static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UsersService service;
	
	@PostMapping("/save")
	public ResponseEntity<Users> saveUser( @RequestBody Users user ) {
		logger.info("Saving information for user " + user.getUserName());
		return new ResponseEntity<Users>( service.saveUser(user), HttpStatus.CREATED );
	}
	
	@GetMapping("/list")
	public List<Users> getAllUsers() {
		logger.info("Getting all the users");
		return service.getAllUsers();
	}

	@GetMapping("/listUserDetails")
	public List<Users> getAllUserDetails() {
		logger.info("Getting all the users details");
		return service.getAllUserDetails();
	}
	
	@GetMapping("/getUserDetails/{id}")
	public Users getUserDetails( @PathVariable("id") Integer id ) {
		logger.info("Getting the details for user with id " + id);
		return service.getUserDetails(id);
	}
	
	@PostMapping("/update")
	public Users updateUser( @RequestBody Users user ) {
		logger.info("Updating information for user " + user.getUserName());
		return service.updateUser(user);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteUser( @PathVariable("id") Integer id ) {
		logger.info("Deletting info for user with id " + id);
		service.deleteUser(id);
	}
	
}

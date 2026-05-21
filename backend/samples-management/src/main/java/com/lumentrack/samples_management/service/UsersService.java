package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.samples_management.model.Users;
import com.lumentrack.samples_management.repository.UsersRepository;

@Service
public class UsersService {

	private final static Logger logger = LoggerFactory.getLogger(UsersService.class);

	@Autowired
	private UsersRepository repository;

	public Users saveUser(Users user) {
		logger.info("Saving information for user " + user.getUserName());
		return repository.save(user);
	}

	public Users getUserDetails(Integer id) {
		logger.info("Retrieving information for user with id " + id);
		Users user = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("User con id " + id + " no existe."));

		logger.info("User with id " + id + " found: " + user.getUserName());

		return Users.builder().userId(user.getUserId()).userName(user.getUserName())
				.userLastName(user.getUserLastName()).userMail(user.getUserMail())
				.userPhoneNumber(user.getUserPhoneNumber()).userRole(user.getUserRole()).build();
	}

	public List<Users> getAllUsers() {
		logger.info("Retrieving all the users");
		return repository.findAll();
	}

	@Transactional
	public Users updateUser(Users userUpdated) {
		logger.info("Updating the task: " + userUpdated.getUserName());

		return repository.findById(userUpdated.getUserId()).map(users -> {
			users.setUserName(userUpdated.getUserName());
			users.setUserLastName(userUpdated.getUserLastName());
			users.setUserMail(userUpdated.getUserMail());
			users.setUserPhoneNumber(userUpdated.getUserPhoneNumber());
			users.setUserRole(userUpdated.getUserRole());
			return users;
		}).orElseThrow(() -> new RuntimeException("Tarea no encontrada"));

	}

	public void deleteUser(Integer id) {
		// Verify if user exists
		Users user = repository.findById(id)
				.orElseThrow(() -> new RuntimeException("Usuario no encontrado con id: " + id));
		
		logger.info("User with id " + id + " has been found!!!");
		logger.info("Deletting information for user " + user.getUserName() );
		repository.deleteById( user.getUserId() );
	}
}

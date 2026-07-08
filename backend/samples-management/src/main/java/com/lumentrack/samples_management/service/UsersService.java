package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.commons.model.Users;
import com.lumentrack.commons.repository.UsersRepository;

@Service
public class UsersService {

	private final static Logger logger = LoggerFactory.getLogger(UsersService.class);

	private final UsersRepository repository; // Hacerlo final

    @Autowired // Inyección por constructor
    public UsersService(UsersRepository repository) {
        this.repository = repository;
    }

	public Users saveUser(Users user) {
		logger.info("Saving information for user " + user.getUserName());
		return repository.save(user);
	}

	public Users getUserDetails(Integer id) {
		logger.info("Retrieving information for user with id " + id);
		Users user = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("User con id " + id + " no existe."));

		logger.info("User with id " + id + " found: " + user.getUserName());

		return Users.builder().userId(
				user.getUserId())
				.userName(user.getUserName())
				.userLastName(user.getUserLastName())
				.userMail(user.getUserMail())
				.userPhoneNumber(user.getUserPhoneNumber())
				.userRoleId(user.getUserRoleId())
				.build();
	}

	public List<Users> getAllUsers() {
		logger.info("Retrieving all the users");
		return repository.findAll();
	}

	@Transactional
	public Users updateUser(Users userUpdated) { // El tipo de retorno sigue siendo Users, pero devolveremos un DTO-like
		logger.info("Updating the user: " + userUpdated.getUserName());

		Users updatedUserEntity = repository.findById(userUpdated.getUserId()).map(users -> {
			users.setUserName(userUpdated.getUserName());
			users.setUserLastName(userUpdated.getUserLastName());
			users.setUserMail(userUpdated.getUserMail());
			users.setUserPhoneNumber(userUpdated.getUserPhoneNumber());
			users.setUserRoleId(userUpdated.getUserRoleId());
			// No actualizamos la contraseña aquí, ya que este servicio no la maneja directamente.
			// Si se necesita actualizar la contraseña, debería ser a través de un método específico.
			return repository.save(users);
		}).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + userUpdated.getUserId()));

		// Devolver un objeto Users "DTO-like" para evitar problemas de serialización
		return Users.builder()
				.userId(updatedUserEntity.getUserId())
				.userName(updatedUserEntity.getUserName())
				.userLastName(updatedUserEntity.getUserLastName())
				.userMail(updatedUserEntity.getUserMail())
				.userPhoneNumber(updatedUserEntity.getUserPhoneNumber())
				.userRoleId(updatedUserEntity.getUserRoleId())
				.build();
	}

	public void deleteUser(Integer id) {
		// Verify if user exists
		Users user = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + id));
		
		logger.info("User with id " + id + " has been found!!!");
		logger.info("Deletting information for user " + user.getUserName() );
		repository.deleteById( user.getUserId() );
	}
}
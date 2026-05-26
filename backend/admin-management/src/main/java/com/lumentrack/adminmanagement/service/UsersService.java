package com.lumentrack.adminmanagement.service;

import com.lumentrack.adminmanagement.exception.ResourceNotFoundException;
import com.lumentrack.adminmanagement.model.Roles;
import com.lumentrack.adminmanagement.model.Users;
import com.lumentrack.adminmanagement.repository.RolesRepository;
import com.lumentrack.adminmanagement.repository.UsersRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UsersService {

	private final static Logger logger = LoggerFactory.getLogger(UsersService.class);

	@Autowired
	private UsersRepository repository;

	@Autowired
	private RolesRepository roleRepository;

	public Users saveUser(Users user) {
		logger.info("Saving information for user " + user.getUserName());
		return repository.save(user);
	}

	public Users getUserDetails(Integer id) {
		logger.info("Retrieving information for user with id " + id);
		Users user = repository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("User con id " + id + " no existe."));

		logger.info("User with id " + id + " found: " + user.getUserName());

		logger.info("Get Role information for " + user.getUserName());

		Optional<Roles> role = roleRepository.findById( user.getUserRoleId() );

		logger.info( "The user: " + user.getUserName() + " has the role: " + role.get().getRoleDisplayName() );

		return Users.builder()
				.userId(user.getUserId())
				.userName(user.getUserName())
				.userLastName(user.getUserLastName())
				.userMail(user.getUserMail())
				.userPhoneNumber(user.getUserPhoneNumber())
				.userRoleId(user.getUserRoleId())
				.roleDisplayName( role.get().getRoleDisplayName() )
				.build();
	}

	public List<Users> getAllUsers() {
		logger.info("Retrieving all the users");
		return repository.findAll();
	}

	public List<Users> getAllUserDetails() {
		logger.info("Getting the User Details");
		List<Users> allUsers = repository.findAll();
		List<Roles> allRoles = roleRepository.findAll();

		Map<Integer, Roles> rolesMap = allRoles.stream().collect(Collectors.toMap(Roles::getRoleId, role -> role));

		return allUsers.stream().map(user -> {
			Roles associatedRole = rolesMap.get(user.getUserRoleId());
			String roleDisplayName = (associatedRole != null) ? associatedRole.getRoleDisplayName() : "Rol No Encontrado";

			return Users.builder()
					.userId(user.getUserId())
					.userName(user.getUserName())
					.userLastName(user.getUserLastName())
					.userMail(user.getUserMail())
					.userPhoneNumber(user.getUserPhoneNumber())
					.userRoleId(user.getUserRoleId())
					.roleDisplayName( roleDisplayName )
					.build();
		}).collect(Collectors.toList());
	}

	@Transactional
	public Users updateUser(Users userUpdated) {
		logger.info("Updating the information for: " + userUpdated.getUserName());

		logger.info( userUpdated.toString() );

		return repository.findById(userUpdated.getUserId()).map(users -> {
			users.setUserName(userUpdated.getUserName());
			users.setUserLastName(userUpdated.getUserLastName());
			users.setUserMail(userUpdated.getUserMail());
			users.setUserPhoneNumber(userUpdated.getUserPhoneNumber());
			users.setUserRoleId(userUpdated.getUserRoleId());
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

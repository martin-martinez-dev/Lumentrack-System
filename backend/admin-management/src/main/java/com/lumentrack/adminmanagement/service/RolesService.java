package com.lumentrack.adminmanagement.service;

import com.lumentrack.adminmanagement.model.Roles;
import com.lumentrack.adminmanagement.repository.RolesRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class RolesService {

    private final static Logger logger = LoggerFactory.getLogger(RolesService.class);

    @Autowired
    private RolesRepository repository;

    public Roles saveRole(Roles role) {
        logger.info("Saving information for role: " + role.getRoleName());
        return repository.save(role);
    }

    public List<Roles> getAllRoles() {
        logger.info("Retrieving all the roles");
        return repository.findAll();
    }

    public Optional<Roles> getRoleById(Integer id) {
        logger.info("Get a single role by id: " + id);
        return repository.findById(id);
    }

    @Transactional
    public Roles updateRole(Roles updatedRole) {
        logger.info("Updating the role: " + updatedRole.getRoleName());
        return repository.findById( updatedRole.getRoleId() ).map( roles -> {
            roles.setRoleName(updatedRole.getRoleName());
            roles.setRoleDisplayName(updatedRole.getRoleDisplayName());
            roles.setRoleDescription(updatedRole.getRoleDescription());
            return repository.save(roles);
        }).orElseThrow( () -> new RuntimeException("Role not found") );
    }

    public void deleteRole(Integer id) {
        // Verifying role exists
        Roles role = repository.findById(id).orElseThrow(() -> new RuntimeException("Role not found with id: " + id));

        logger.info("Role with id: " + id + " has been found!");
        logger.info("Deleting information for the role: " + role.getRoleName() );

        repository.deleteById(role.getRoleId());
    }

}

package com.lumentrack.adminmanagement.controller;

import com.lumentrack.commons.model.Roles;
import com.lumentrack.adminmanagement.service.RolesService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/roles")
@CrossOrigin(origins = "*")
public class RolesController {

    private final static Logger logger = LoggerFactory.getLogger(RolesController.class);

    private final RolesService service; // Hacerlo final

    @Autowired // Inyección por constructor
    public RolesController(RolesService service) {
        this.service = service;
    }

    @PostMapping("/save")
    @PreAuthorize("hasAnyAuthority('SUPER_ADMIN')")
    public ResponseEntity<Roles> saveRole( @RequestBody Roles role ) {
        logger.info("Saving information for role: " + role.getRoleName());
        return new ResponseEntity<Roles>( service.saveRole(role), HttpStatus.CREATED );
    }

    @GetMapping("/list")
    @PreAuthorize("hasAnyAuthority('SUPER_ADMIN')")
    public List<Roles> getAllRoles() {
        logger.info("Retrieving all the roles");
        return service.getAllRoles();
    }

    @GetMapping("/search/{id}")
    @PreAuthorize("hasAnyAuthority('SUPER_ADMIN')")
    public ResponseEntity<Roles> getRoleById( @PathVariable("id") Integer id ) {
        logger.info("Get a single role by id: " + id);
        return service.getRoleById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/update")
    @PreAuthorize("hasAnyAuthority('SUPER_ADMIN')")
    public Roles updateRole( @RequestBody Roles role ) {
        logger.info("Updating the role: " + role.getRoleName());
        return service.updateRole(role);
    }

    @DeleteMapping("/delete/{id}")
    @PreAuthorize("hasAnyAuthority('SUPER_ADMIN')")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteRole( @PathVariable("id") Integer id ) {
        logger.info("Deleting information for the role with id: " + id);
        service.deleteRole(id);
    }

}
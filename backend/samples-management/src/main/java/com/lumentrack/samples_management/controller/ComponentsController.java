package com.lumentrack.samples_management.controller;

import java.util.List;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
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

import com.lumentrack.commons.model.Components;
import com.lumentrack.samples_management.service.ComponentService;
import com.lumentrack.samples_management.requestors.ComponentRequest;
import com.lumentrack.samples_management.requestors.ComponentDetailsResponse;

@RestController
@RequestMapping("/components")
@CrossOrigin(origins = "*")
public class ComponentsController {
	
	private final static Logger logger = LoggerFactory.getLogger(ComponentsController.class);
	
	private final ComponentService service; // Hacerlo final

    @Autowired // Inyección por constructor
    public ComponentsController(ComponentService service) {
        this.service = service;
    }
	
	@PostMapping("/save")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public ResponseEntity<Components> saveComponent(@RequestBody ComponentRequest componentRequest) {
		logger.info("Start saving of component: " + componentRequest.getComponentName());
		return new ResponseEntity<>(service.saveComponent(componentRequest),HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'PRODUCTION', 'SALES')")
	public List<Components> retrieveAll() { // Revertido a List<Components>
		logger.info("Listing all the components");
		return service.getAllComponent(); // Llama al método que devuelve List<Components>
	}

	@GetMapping("/list/user/{userId}")
	@PreAuthorize("hasAnyAuthority('DESIGN')")
	public List<Components> retrieveComponentsByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing components for userId: " + userId);
		return service.getComponentsByUserId(userId);
	}
	
	@GetMapping("/search/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')")
	public ResponseEntity<Components> searchComponentById(@PathVariable("id") Integer id) {
		logger.info("Search component by id: " + id);
		return service.getComponentById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')")
	public ComponentDetailsResponse updateComponent(@RequestBody ComponentRequest componentRequest) { // CAMBIADO: Tipo de retorno a ComponentDetailsResponse
		logger.info("Updating info for component: " + componentRequest.getComponentName());
		return service.updateComponent(componentRequest);
	}
	
	@DeleteMapping("/delete/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteComponent(@PathVariable("id") Integer id) {
		logger.info("Deleting info for component id: " + id);
		service.deleteComponent(id);
	}
	
	@GetMapping("/getComponentDetails/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')")
	public ComponentDetailsResponse getComponentDetails( @PathVariable("id") Integer id ) {
		logger.info("Getting the Details of the Component with id: " + id);
		// Este método ahora usa el findById original y luego mapea
		Components component = service.getComponentById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Componente con id " + id + " no existe."));
		return service.mapComponentToComponentDetailsResponse(component);
	}

	// NUEVO: Endpoint para listar todos los componentes con detalles
	@GetMapping("/list/details")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public List<ComponentDetailsResponse> retrieveAllComponentDetails() {
		logger.info("Listing all component details");
		return service.getAllComponentDetails();
	}

	// NUEVO: Endpoint para buscar un componente por ID con detalles
	@GetMapping("/search/details/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN', 'DESIGN')")
	public ComponentDetailsResponse searchComponentDetailsById(@PathVariable("id") Integer id) {
		logger.info("Search component details by id: " + id);
		return service.getComponentDetailsById(id);
	}
	
}
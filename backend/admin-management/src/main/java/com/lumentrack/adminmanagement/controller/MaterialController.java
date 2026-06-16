package com.lumentrack.adminmanagement.controller;

import com.lumentrack.commons.model.Materials;
import com.lumentrack.adminmanagement.service.MaterialService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/materials")
@CrossOrigin(origins = "*")
public class MaterialController {
	
	private final static Logger logger = LoggerFactory.getLogger(MaterialController.class);
	
	private final MaterialService service; // Hacerlo final

    @Autowired // Inyección por constructor
    public MaterialController(MaterialService service) {
        this.service = service;
    }
	
	@PostMapping("/save")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public ResponseEntity<Materials> saveMaterial(@RequestBody Materials material) {
		logger.info("Save info for material: " + material.getMaterialName());
		return new ResponseEntity<Materials>(service.saveMaterial(material), HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public List<Materials> retrieveMaterials(){
		logger.info("Getting the info for all the materials");
		return service.getAllMaterials();
	}
	
	@GetMapping("/search/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public ResponseEntity<Materials> searchMaterialById(@PathVariable("id") Integer id){
		logger.info("Search material by id: " + id);
		
		return service.getMaterialById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	public Materials updateMaterial(@RequestBody Materials material) {
		logger.info("Updating info for material: " + material.getMaterialName());
		return service.updateMaterialInformation(material);
	}
	
	@DeleteMapping("/delete/{id}")
	@PreAuthorize("hasAnyAuthority('SUPER_ADMIN', 'ADMIN')")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteMaterial(@PathVariable("id") Integer id) {
		logger.info("Deleting information for material id: " + id);
		service.deleteMaterialById(id);
	}
	
}
package com.lumentrack.adminmanagement.service;

import com.lumentrack.adminmanagement.model.Materials;
import com.lumentrack.adminmanagement.repository.MaterialsRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class MaterialService {
	
	private final static Logger logger = LoggerFactory.getLogger(MaterialService.class);
	
	@Autowired
	private MaterialsRepository repository;
	
	public Materials saveMaterial(Materials material) {
		logger.info("Saving information for Material: " + material.getMaterialName());
		return repository.save(material);
	}
	
	public List<Materials> getAllMaterials() {
		logger.info("Retrieving all the materials");
		return repository.findAll();
	}
	
	public Optional<Materials> getMaterialById(Integer id) {
		logger.info("Retrieving material with id: " + id);
		return repository.findById(id);
	}
	
	@Transactional
	public Materials updateMaterialInformation(Materials updatedMaterial) {
		logger.info("Updating information for material: " + updatedMaterial.getMaterialName());
		return repository.findById( updatedMaterial.getMaterialId() ).map(materials -> {
			materials.setMaterialName( updatedMaterial.getMaterialName() );
			return repository.save(materials);
		}).orElseThrow( () -> new RuntimeException("Muestra no encontrada") );
	}
	
	public void deleteMaterialById(Integer id) {
		logger.info("Deleting information for material with id: " + id);
		//Verifying that the Material exists
		Materials material = repository.findById(id)
				.orElseThrow(() -> new RuntimeException("Material no encontrado con id: " + id));
		
		logger.info("Material with id: " + id + " has been found!!!");
		logger.info("Deleting information for material: " + material.getMaterialName());
		repository.deleteById(id);
	}
}

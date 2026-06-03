package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Components; // Paquete actualizado

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ComponentsRepository extends JpaRepository<Components, Integer> {
	
	// Cambiado de findBySampleId a findBySample_SampleId para reflejar la relación JPA
	List<Components> findBySample_SampleId(Integer sampleId);
	
	// Nuevo método para buscar componentes por userId
	List<Components> findByUserId(Integer userId);
	
}
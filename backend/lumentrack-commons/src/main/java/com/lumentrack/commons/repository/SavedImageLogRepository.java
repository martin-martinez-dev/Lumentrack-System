package com.lumentrack.commons.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lumentrack.commons.model.SavedImageLog; // Paquete actualizado

@Repository
public interface SavedImageLogRepository extends JpaRepository<SavedImageLog, Integer> {
	
	Optional<SavedImageLog> findByImageCloudinaryId(String imageCloudinaryId);
	
}
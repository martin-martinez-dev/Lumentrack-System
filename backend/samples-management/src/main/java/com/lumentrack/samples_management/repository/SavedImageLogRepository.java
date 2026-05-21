package com.lumentrack.samples_management.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lumentrack.samples_management.model.SavedImageLog;

@Repository
public interface SavedImageLogRepository extends JpaRepository<SavedImageLog, Integer> {
	
	Optional<SavedImageLog> findByImageCloudinaryId(String imageCloudinaryId);
	
}

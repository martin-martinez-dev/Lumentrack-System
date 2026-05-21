package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Components;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ComponentsRepository extends JpaRepository<Components, Integer> {
	
	List<Components> findBySampleId(Integer sampleId);
	
}

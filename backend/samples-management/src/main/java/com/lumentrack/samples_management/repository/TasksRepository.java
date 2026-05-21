package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Tasks;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TasksRepository extends JpaRepository<Tasks, Integer> {
	
	List<Tasks> findByComponentId(Integer componentId);
	
}

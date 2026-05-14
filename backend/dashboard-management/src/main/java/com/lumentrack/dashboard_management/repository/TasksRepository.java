package com.lumentrack.dashboard_management.repository;

import com.lumentrack.dashboard_management.model.Tasks;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface TasksRepository extends JpaRepository<Tasks, Integer> {
	
	@Query("SELECT t FROM Tasks t ORDER BY t.taskEstimatedDate ASC NULLS LAST")
	List<Tasks> findAllSortedByTaskEstimatedDate(Pageable pageable);
	
}

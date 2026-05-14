package com.lumentrack.dashboard_management.repository;

import com.lumentrack.dashboard_management.model.Samples;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface SamplesRepository extends JpaRepository<Samples, Integer> {
	
	@Query("SELECT s FROM Samples s ORDER BY s.estimatedDeliveryDate ASC NULLS LAST")
	List<Samples> findAllSortedByEstimatedDeliveryDate(Pageable pageable);
}

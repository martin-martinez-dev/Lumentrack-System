package com.lumentrack.dashboard_management.repository;

import com.lumentrack.dashboard_management.model.Orders;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface OrdersRepository extends JpaRepository<Orders, Integer> {
	
	@Query("SELECT o FROM Orders o ORDER BY o.estimatedDeliveryDate ASC NULLS LAST")
	List<Orders> findAllSortedByEstimatedDeliveryDate(Pageable pageable);
}

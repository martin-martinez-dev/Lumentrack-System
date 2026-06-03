package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Samples; // Paquete actualizado

import java.util.List;

import org.springframework.data.domain.Pageable; // Nueva importación
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Nueva importación
import org.springframework.stereotype.Repository;

@Repository
public interface SamplesRepository extends JpaRepository<Samples, Integer> {
	
	// Cambiado de findByOrderId a findByOrder_OrderId para reflejar la relación JPA
	List<Samples> findByOrder_OrderId(Integer orderId);
	
	// Nuevo método para buscar Samples por userId de sus Components
	@Query("SELECT DISTINCT s FROM Samples s JOIN s.components c WHERE c.userId = :userId")
	List<Samples> findByComponentsUserId(Integer userId);

	// NUEVO: Método para encontrar todas las muestras ordenadas por fecha estimada de entrega
	List<Samples> findAllByOrderByEstimatedDeliveryDateDesc(Pageable pageable);
}
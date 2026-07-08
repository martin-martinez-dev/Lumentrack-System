package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Samples;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SamplesRepository extends JpaRepository<Samples, Integer> {
	
	// Cambiado de findByOrderId a findByOrder_OrderId para reflejar la relación JPA
	List<Samples> findByOrder_OrderId(Integer orderId);
	
	// Nuevo método para buscar Samples por userId de sus Components
	@Query("SELECT DISTINCT s FROM Samples s JOIN s.components c WHERE c.userId = :userId")
	List<Samples> findByComponentsUserId(Integer userId);

	// NUEVO: Método para encontrar todas las muestras ordenadas por fecha estimada de entrega
	List<Samples> findAllByOrderByEstimatedDeliveryDateDesc(Pageable pageable);

	// NUEVO: Método para cargar todas las muestras con su orden y componentes asociadas en una sola consulta
	@Query("SELECT DISTINCT s FROM Samples s LEFT JOIN FETCH s.order LEFT JOIN FETCH s.components")
	List<Samples> findAllWithOrderAndComponents();

	// NUEVO: Método para cargar una muestra por ID con su orden y componentes asociadas en una sola consulta
	@Query("SELECT s FROM Samples s LEFT JOIN FETCH s.order LEFT JOIN FETCH s.components WHERE s.sampleId = :sampleId")
	Optional<Samples> findByIdWithOrderAndComponents(Integer sampleId);

	// NUEVO: Método para buscar Samples por userId de sus Components, cargando Order, Components y Tasks
	@Query("SELECT DISTINCT s FROM Samples s LEFT JOIN FETCH s.order o LEFT JOIN FETCH s.components c LEFT JOIN FETCH c.tasks WHERE c.userId = :userId")
	List<Samples> findByComponentsUserIdWithOrderAndComponents(Integer userId);
}
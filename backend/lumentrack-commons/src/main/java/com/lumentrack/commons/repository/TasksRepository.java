package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Tasks; // Paquete actualizado

import java.util.List;

import org.springframework.data.domain.Pageable; // Nueva importación
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Nueva importación
import org.springframework.stereotype.Repository;

@Repository
public interface TasksRepository extends JpaRepository<Tasks, Integer> {
	
	// Cambiado de findByComponentId a findByComponent_ComponentId para reflejar la relación JPA
	List<Tasks> findByComponent_ComponentId(Integer componentId);
	
	// Nuevo método para buscar Tasks por userId de sus Components
	@Query("SELECT DISTINCT t FROM Tasks t JOIN t.component c WHERE c.userId = :userId")
	List<Tasks> findByComponentsUserId(Integer userId);

	// NUEVO: Método para encontrar todas las tareas ordenadas por fecha estimada de entrega
	List<Tasks> findAllByOrderByTaskEstimatedDateDesc(Pageable pageable);
}
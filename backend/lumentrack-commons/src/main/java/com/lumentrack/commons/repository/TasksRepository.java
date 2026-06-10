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
	// Este método derivado no puede usar FETCH JOIN para colecciones.
	List<Tasks> findByComponent_ComponentId(Integer componentId);
	
	// MODIFICADO: Método para buscar Tasks por userId de sus Components, cargando el Component asociado
	@Query("SELECT DISTINCT t FROM Tasks t LEFT JOIN FETCH t.component c WHERE c.userId = :userId")
	List<Tasks> findByComponentsUserIdWithComponent(Integer userId); // Renombrado para reflejar el cambio

	// NUEVO: Método para encontrar todas las tareas ordenadas por fecha estimada de entrega, cargando el Component
	@Query("SELECT DISTINCT t FROM Tasks t LEFT JOIN FETCH t.component ORDER BY t.taskEstimatedDate DESC")
	List<Tasks> findAllByOrderByTaskEstimatedDateDescWithComponent(Pageable pageable); // Nuevo método con FETCH JOIN

	// Se mantiene el método original si se necesita sin el FETCH JOIN
	List<Tasks> findAllByOrderByTaskEstimatedDateDesc(Pageable pageable);
}
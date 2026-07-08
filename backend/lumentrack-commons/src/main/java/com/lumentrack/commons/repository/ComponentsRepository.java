package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Components;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComponentsRepository extends JpaRepository<Components, Integer> {
	
	// Cambiado de findBySampleId a findBySample_SampleId para reflejar la relación JPA
	// Este método derivado no puede usar FETCH JOIN para colecciones, pero si para ManyToOne.
	// Si se necesita el sample eager, se puede crear un método @Query.
	// Por ahora, lo dejamos como está, asumiendo que el sample se carga en otro contexto o lazy.
	List<Components> findBySample_SampleId(Integer sampleId);
	
	// Nuevo método para buscar componentes por userId
	// Este método derivado no puede usar FETCH JOIN para colecciones.
	// Si se necesita el sample o tasks eager, se puede crear un método @Query.
	List<Components> findByUserId(Integer userId);

	// MODIFICADO: Método para cargar todos los componentes con sus tareas y sample asociadas en una sola consulta
	@Query("SELECT DISTINCT c FROM Components c LEFT JOIN FETCH c.tasks LEFT JOIN FETCH c.sample")
	List<Components> findAllWithTasksAndSample(); // Renombrado para reflejar el cambio

	// MODIFICADO: Método para cargar un componente por ID con sus tareas y sample asociadas en una sola consulta
	@Query("SELECT c FROM Components c LEFT JOIN FETCH c.tasks LEFT JOIN FETCH c.sample WHERE c.componentId = :componentId")
	Optional<Components> findByIdWithTasksAndSample(Integer componentId); // Renombrado para reflejar el cambio
}
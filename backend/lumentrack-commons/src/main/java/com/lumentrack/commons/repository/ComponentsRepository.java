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
	List<Components> findBySample_SampleId(Integer sampleId);
	
	// Nuevo método para buscar componentes por userId
	List<Components> findByUserId(Integer userId);

	// NUEVO: Método para cargar todos los componentes con sus tareas asociadas en una sola consulta
	// Se eliminó 'LEFT JOIN FETCH c.user' ya que 'user' no es una relación directa en la entidad Components
	@Query("SELECT DISTINCT c FROM Components c LEFT JOIN FETCH c.tasks")
	List<Components> findAllWithTasksAndUser();

	// NUEVO: Método para cargar un componente por ID con sus tareas asociadas en una sola consulta
	// Se eliminó 'LEFT JOIN FETCH c.user' ya que 'user' no es una relación directa en la entidad Components
	@Query("SELECT c FROM Components c LEFT JOIN FETCH c.tasks WHERE c.componentId = :componentId")
	Optional<Components> findByIdWithTasksAndUser(Integer componentId);
}
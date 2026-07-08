package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Materials; // Paquete actualizado
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MaterialsRepository extends JpaRepository<Materials, Integer> {
}
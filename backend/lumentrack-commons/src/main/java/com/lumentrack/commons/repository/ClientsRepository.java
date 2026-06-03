package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Clients; // Paquete actualizado
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientsRepository extends JpaRepository<Clients, Integer> {
}
package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Clients;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientsRepository extends JpaRepository<Clients, Integer> {
}

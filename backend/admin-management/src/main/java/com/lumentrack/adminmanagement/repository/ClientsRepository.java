package com.lumentrack.adminmanagement.repository;

import com.lumentrack.adminmanagement.model.Clients;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientsRepository extends JpaRepository<Clients, Integer> {
}

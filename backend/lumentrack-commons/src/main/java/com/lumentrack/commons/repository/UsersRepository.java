package com.lumentrack.commons.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lumentrack.commons.model.Users; // Paquete actualizado

@Repository
public interface UsersRepository extends JpaRepository<Users, Integer> {
}
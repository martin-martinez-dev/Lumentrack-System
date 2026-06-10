package com.lumentrack.commons.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lumentrack.commons.model.Users; // Paquete actualizado

import java.util.Optional; // Importar Optional

@Repository
public interface UsersRepository extends JpaRepository<Users, Integer> {
    // Añadido para buscar usuarios por su correo electrónico
    Optional<Users> findByUserMail(String userMail);
}
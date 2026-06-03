package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Orders; // Paquete actualizado
import org.springframework.data.domain.Pageable; // Nueva importación
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Nueva importación
import org.springframework.stereotype.Repository;

import java.util.List; // Nueva importación

@Repository
public interface OrdersRepository extends JpaRepository<Orders, Integer> {

    // Nuevo método para buscar Orders por userId de sus Components
    @Query("SELECT DISTINCT o FROM Orders o JOIN o.samples s JOIN s.components c WHERE c.userId = :userId")
    List<Orders> findByComponentsUserId(Integer userId);

    // NUEVO: Método para encontrar todas las órdenes ordenadas por fecha estimada de entrega
    List<Orders> findAllByOrderByEstimatedDeliveryDateDesc(Pageable pageable);
}
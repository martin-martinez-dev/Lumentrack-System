package com.lumentrack.commons.repository;

import com.lumentrack.commons.model.Orders;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrdersRepository extends JpaRepository<Orders, Integer> {

    // Nuevo método para buscar Orders por userId de sus Components
    @Query("SELECT DISTINCT o FROM Orders o JOIN o.samples s JOIN s.components c WHERE c.userId = :userId")
    List<Orders> findByComponentsUserId(Integer userId);

    // NUEVO: Método para encontrar todas las órdenes ordenadas por fecha estimada de entrega
    List<Orders> findAllByOrderByEstimatedDeliveryDateDesc(Pageable pageable);

    // NUEVO: Método para cargar todas las órdenes con sus samples asociadas en una sola consulta
    @Query("SELECT DISTINCT o FROM Orders o LEFT JOIN FETCH o.samples")
    List<Orders> findAllWithSamples();

    // NUEVO: Método para buscar Orders por userId de sus Components, cargando Samples, Components y Tasks
    @Query("SELECT DISTINCT o FROM Orders o LEFT JOIN FETCH o.samples s LEFT JOIN FETCH s.components c LEFT JOIN FETCH c.tasks WHERE c.userId = :userId")
    List<Orders> findByComponentsUserIdWithDetails(Integer userId);
}
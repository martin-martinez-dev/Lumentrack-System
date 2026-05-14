package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Components;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ComponentsRepository extends JpaRepository<Components, Integer> {
}

package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Materials;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MaterialsRepository extends JpaRepository<Materials, Integer> {
}

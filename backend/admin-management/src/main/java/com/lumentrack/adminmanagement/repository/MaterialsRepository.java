package com.lumentrack.adminmanagement.repository;

import com.lumentrack.adminmanagement.model.Materials;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MaterialsRepository extends JpaRepository<Materials, Integer> {
}

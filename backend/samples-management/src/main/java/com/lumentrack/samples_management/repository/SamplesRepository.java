package com.lumentrack.samples_management.repository;

import com.lumentrack.samples_management.model.Samples;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SamplesRepository extends JpaRepository<Samples, Integer> {
}

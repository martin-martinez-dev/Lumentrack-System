package com.lumentrack.samples_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lumentrack.samples_management.model.Users;

@Repository
public interface UsersRepository extends JpaRepository<Users, Integer> {

}

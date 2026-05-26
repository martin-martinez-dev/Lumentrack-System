package com.lumentrack.adminmanagement.repository;

import com.lumentrack.adminmanagement.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsersRepository extends JpaRepository<Users, Integer> {

}

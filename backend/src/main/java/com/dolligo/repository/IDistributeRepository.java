package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paper;
import com.dolligo.dto.User;

@Repository
public interface IDistributeRepository extends JpaRepository<Paper, Integer>{
	@Query(value = "select * from paper ", nativeQuery = true)
    List<Paper> getAllPaper();
    

}

package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paperstate;

@Repository
public interface IPaperStateRepository extends JpaRepository<Paperstate, Integer>{
	
	@Query(value = "select * from paperstate where uid = ?1", nativeQuery = true)
    List<Paperstate> findAllByUid(String uid);

}

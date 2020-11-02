package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.PaperAnalysis;
import com.dolligo.dto.Paperstate;

@Repository
public interface IPaperAnalysisRepository extends JpaRepository<PaperAnalysis, Integer>{

//	@Query(value = "update paperanalysis set ignore = ignore+1 where pid = ?1", nativeQuery = true)
//	void updateIgnore(int pid);

	@Query(value = "select * from paperanalysis where pid = ?1", nativeQuery = true)
	PaperAnalysis findByPid(int pid);
	
    

}

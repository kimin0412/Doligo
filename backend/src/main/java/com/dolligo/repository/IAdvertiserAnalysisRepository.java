package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Paperanalysis;

@Repository
public interface IAdvertiserAnalysisRepository extends JpaRepository<AdvertiserAnalysis, Integer>{
//	@Query(value = "select * from paperanalysis where aid = ?1 order by id DESC limit 1", nativeQuery = true)
//	Paperanalysis getPaperAnalysis(int aid);
//	
    

}

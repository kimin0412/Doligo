package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Paperstate;

@Repository
public interface IAdvertiserAnalysisRepository extends JpaRepository<AdvertiserAnalysis, Integer>{
	
    

}

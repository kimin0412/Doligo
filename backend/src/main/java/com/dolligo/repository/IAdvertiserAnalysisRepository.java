package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.AdvertiserAnalysis;

@Repository
public interface IAdvertiserAnalysisRepository extends JpaRepository<AdvertiserAnalysis, Integer>{
	@Query(value = "select * from advertiseranalysis where aid = ?1", nativeQuery = true)
	List<AdvertiserAnalysis> getAllAdvertiserAnalysis(int aid);
//	
	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=1 and (state=2 or state=3)", nativeQuery = true)
	int getGenderMan(int aid);
	
	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=0 and (state=2 or state=3)", nativeQuery = true)
	int getGenderWoman(int aid);
	
//	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=1 and (state=2 or state=3)", nativeQuery = true)
//	int getGenderMan(int aid);
//	
//	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=0 and (state=2 or state=3)", nativeQuery = true)
//	int getGenderWoman(int aid);
}

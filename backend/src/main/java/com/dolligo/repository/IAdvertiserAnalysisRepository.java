package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.TimeGraph;

@Repository
public interface IAdvertiserAnalysisRepository extends JpaRepository<AdvertiserAnalysis, Integer>{
	@Query(value = "select * from advertiseranalysis where aid = ?1", nativeQuery = true)
	List<AdvertiserAnalysis> getAllAdvertiserAnalysis(int aid);
//	
	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=1 and (state=2 or state=3)", nativeQuery = true)
	int getGenderMan(int aid);
	
	@Query(value = "select count(*) from advertiseranalysis where aid = ?1 and gender=0 and (state=2 or state=3)", nativeQuery = true)
	int getGenderWoman(int aid);
	
//	@Query(value = "select count(case when aid = ?1 and state=1 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as deleteCnt, "
//			+ "count(case when aid = ?1 and state=2 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as pointCnt, "
//			+ "count(case when aid = ?1 and state=3 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as visitCnt, "
//			+ "count(case when aid = ?1 and state=4 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as blockCnt "
//			+ "from advertiseranalysis", nativeQuery = true)
//	TimeGraph getTimeCnt(int aid, String start, String end);
	
	
}

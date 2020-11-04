package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.TimeGraph;

@Repository
public interface ITimeGraphRepository extends JpaRepository<TimeGraph, Integer>{
	@Query(value = "select count(case when aid = ?1 and state=1 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as delete_cnt, "
			+ "count(case when aid = ?1 and state=2 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as point_cnt, "
			+ "count(case when aid = ?1 and state=3 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as visit_cnt, "
			+ "count(case when aid = ?1 and state=4 and (CAST(time as time) >= ?2 and CAST(time as time) < ?3) then 1 end) as block_cnt "
			+ "from advertiseranalysis", nativeQuery = true)
	TimeGraph getTimeCnt(int aid, String start, String end);
}

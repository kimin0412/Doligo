package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paper;
import com.dolligo.dto.RandomGps;
import com.dolligo.dto.TimeGraph;

@Repository
public interface IRandomGpsRepository extends JpaRepository<RandomGps, Integer>{
		
	@Query(value = "select * from random_gps " + 
			"where " + 
			"(6371 * acos(cos(radians(37.500628)) * cos(radians(37 + lat)) * " + 
			"cos(radians(127 + lon) - radians(127.036436)) + sin(radians(37.500628)) * sin(radians(37 + lat)))) < 1 order by rand() limit 0, 1100", nativeQuery = true)
	List<RandomGps> findAllByGps();
}

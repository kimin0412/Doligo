package com.dolligo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paperstate;
import com.dolligo.dto.PointLog;

@Repository
public interface IPointLogRepository extends JpaRepository<PointLog, Integer>{

	@Query(value = "select * from point_log where uid = ?1 order by created desc", nativeQuery = true)
	List<PointLog> findAllByUid(String uid);

	@Query(value = "select * from point_log where uid = ?1 and created between ?2 and ?3 order by created desc", nativeQuery = true)
	List<PointLog> findAllByUidForMonth(String uid, LocalDateTime start, LocalDateTime end);


}

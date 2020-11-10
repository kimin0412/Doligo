package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Preference;

@Repository
public interface IPreferenceRepository extends JpaRepository<Preference, Integer>{

	@Query(value = "select * from preference where uid = ?1 and mid = ?2 ", nativeQuery = true)
	Preference findByUidAndMid(String uid, int p_mtid);

	@Query(value = "select * from preference where uid = ?1 order by mid ", nativeQuery = true)
	List<Preference> findAllByUid(String uid);
}

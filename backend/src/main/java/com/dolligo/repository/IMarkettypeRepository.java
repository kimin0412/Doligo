package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.dolligo.dto.Markettype;
import com.dolligo.dto.Preference;

public interface IMarkettypeRepository extends JpaRepository<Markettype, Integer>{
	@Query(value = "select id from markettype where largecode = ?1", nativeQuery = true)
	List<Integer> findByLargecode(String largecode);
}

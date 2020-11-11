package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Gifticon;

@Repository
public interface IGifticonRepository extends JpaRepository<Gifticon, Integer>{

	@Query(value = "select * from gifticon where category = ?1 and purchase = 0 and valid_date >= date(now())", nativeQuery = true)
	List<Gifticon> findAllValidGift(int cid);
	
}

package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.GifticonPurchase;

@Repository
public interface IGifticonPurchaseRepository extends JpaRepository<GifticonPurchase, Integer>{
	
	@Query(value = "select * from gifticon_purchase where uid = ?1 ", nativeQuery = true)
	List<GifticonPurchase> selectPurchaseList(int uid);
	
	@Query(value = "select * from gifticon_purchase where uid = ?1 and id=?2", nativeQuery = true)
	GifticonPurchase selectPurchaseDetail(int uid, int id);
}

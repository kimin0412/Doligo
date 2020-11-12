package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.GifticonPurchase;

@Repository
public interface IGifticonPurchaseRepository extends JpaRepository<GifticonPurchase, Integer>{
	
}

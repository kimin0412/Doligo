package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Coupon;

@Repository
public interface ICouponRepository extends JpaRepository<Coupon, Integer>{
	
    

}

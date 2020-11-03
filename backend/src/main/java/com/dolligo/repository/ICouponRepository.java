package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Coupon;

@Repository
public interface ICouponRepository extends JpaRepository<Coupon, Integer>{

	@Query(value = "select * from coupon where uid = ?1 and pid = ?2 ", nativeQuery = true)
	Coupon findByPidAndUid(String uid, int pid);

	//쿠폰 기한 30일로 해둠( and timestampdiff(day, created, now()) < 31)
	@Query(value = "select * from coupon where uid = ?1 and used = false ", nativeQuery = true)
	List<Coupon> findAllByUid(String uid);
	
    

}

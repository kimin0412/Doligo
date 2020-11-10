package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Advertiser;

@Repository
public interface IAdvertiserRepository extends JpaRepository<Advertiser, Integer>{
	@Query(value = "select * from advertiser where email = ?1 ", nativeQuery = true)
	Advertiser getAdvertiserByEmail(String email);
	
//	AdvertiserMapping findById(int aid);
	
    
	//이메일 중복체크
	@Query(value = "select count(email) from advertiser where email = ?1", nativeQuery = true)
	int isDupEmail(String email);
	
	//비밀번호 찾기
	@Query(value = "select count(id) from advertiser where id = ?1 and password = ?2", nativeQuery = true)
	int checkPassword(String id, String password);
	
	//비밀번호 변경
	@Query(value = "update advertiser set password = ?2 where email = ?1", nativeQuery = true)
	void updatePasswordByEmail(String email, String password);
	
	//비밀번호 보기
	@Query(value = "select password from advertiser where id = ?1", nativeQuery = true)
	String selectPassword(int userId);
	
	//가게정보 보기
	@Query(value = "select marketname, marketbranch, marketnumber, marketaddress, marketurl from advertiser where id = ?1", nativeQuery = true)
	Advertiser selectMarket(int userId);

}

package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Advertiser;

@Repository
public interface IAdvertiserPaperRepository {
	@Query(value = "select * from Advertiser where id = ?1 ", nativeQuery=true)
	List<Advertiser> getAdvertiserById(int id);

}

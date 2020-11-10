package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Block;
import com.dolligo.dto.Paperstate;

@Repository
public interface IBlockRepository extends JpaRepository<Block, Integer>{

	@Query(value = "select * from block where uid = ?1", nativeQuery = true)
	List<Block> findAllByUid(String uid);

	@Query(value = "delete from block where uid = ?1 and aid = ?2", nativeQuery = true)
	void deleteByUidAndAid(String uid, int aid);

	
    

}

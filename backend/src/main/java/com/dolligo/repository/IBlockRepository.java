package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Block;
import com.dolligo.dto.Paperstate;

@Repository
public interface IBlockRepository extends JpaRepository<Block, Integer>{
	
    

}

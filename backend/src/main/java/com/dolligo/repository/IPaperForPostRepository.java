package com.dolligo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.PaperForList;
import com.dolligo.dto.PaperForPost;

@Repository
public interface IPaperForPostRepository extends JpaRepository<PaperForPost, Integer>{
	
}

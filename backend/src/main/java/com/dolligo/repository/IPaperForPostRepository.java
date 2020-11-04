package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.PaperForPost;

@Repository
public interface IPaperForPostRepository extends JpaRepository<PaperForPost, Integer>{

}

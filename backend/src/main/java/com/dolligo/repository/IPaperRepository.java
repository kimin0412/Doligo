package com.dolligo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForList;
import com.dolligo.dto.User;
import com.dolligo.mapping.PaperMapping;

@Repository
public interface IPaperRepository extends JpaRepository<Paper, Integer>{
	@Query(value = "select * from paper ", nativeQuery = true)
    List<Paper> getAllPaper();
	
	@Query(value = "select * from paper where p_aid = ?1 order by p_id DESC limit 1", nativeQuery = true)
    Paper getRecentPaper(int aid);


//    List<PaperMapping> findAllBy(Pageable pageable);
    
//    PaperMapping findById(int pid);

}

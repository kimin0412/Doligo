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

	@Query(value = "select * from paper where p_aid = ?1 and p_id = ?2 ", nativeQuery = true)
	Paper findByPid(String aid, int pid);

	@Query(value = "select * from paper where p_aid = ?1 ", nativeQuery = true)
	List<Paper> findAllByP_aid(String aid);

	@Query(value = "select count(*) from paper where p_aid = ?1 and p_id = ?2 ", nativeQuery = true)
	int findByAidAndPid(String aid, int pid);


//    List<PaperMapping> findAllBy(Pageable pageable);
    
//    PaperMapping findById(int pid);

}

package com.dolligo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForList;

@Repository
public interface IPaperForListRepository extends JpaRepository<PaperForList, Integer>{
//	@Query(value = "select * from paper ", nativeQuery = true)
//    List<Paper> getAllPaper();

	//현재 시간에 유효한 광고 목록 가져옴
	@Query(value = "select p_id, p_aid, p_mtid, p_image, p_video, p.lat as 'lat', p.lon as 'lon', sheets, marketname, marketaddress"
					+ " from paper p "
					+ " join advertiser a on p.p_aid = a.id "
					+ " where now() between starttime and endtime "
					+ " order by p_mtid ", nativeQuery = true)
	List<PaperForList> findallByTime(LocalDateTime now);
	
	
//    List<PaperMapping> findAllBy(Pageable pageable);
    
//    PaperMapping findById(int pid);

}

package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Paperstate;

@Repository
public interface IPaperStateRepository extends JpaRepository<Paperstate, Integer>{
	
	@Query(value = "select * from paperstate where uid = ?1", nativeQuery = true)
    List<Paperstate> findAllByUid(String uid);
	
	@Query(value = "select * from paperstate where uid = ?1 and point > 1", nativeQuery = true)
    List<Paperstate> findPointList(String uid);//포인트 얻기 or qr인증을 했을 경우만 조회

	@Query(value = "select * from paperstate where pid = ?1 and uid = ?2", nativeQuery = true)
	Paperstate findByUidAndPid(int pid, String uid);

//	@Query(value = "select isget from paperstate where pid = ?1 and uid = ?2", nativeQuery = true)
//	boolean selectIsget(String uid, int pid);

}

package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.User;

@Repository
public interface IUserRepository extends JpaRepository<User, Integer>{
	@Query(value = "select * from User where email = ?1 ", nativeQuery = true)
    User getUserByEmail(String email);
    
//    int create(User user);
//    int update(User user);
//    int delete(String id);
//
//	int isDupEmail(String email);
//	
	//비밀번호 찾기
	@Query(value = "select count(id) from User where id = ?1 and password = ?2", nativeQuery = true)
	int checkPassword(int id, String password);
	
//	@Query("update count(id) from User where id = ?1 and password = ?2")
//	void updatePasswordByEmail(String email, String password);
//	
//	String selectPassword(String userId);

	
	

}

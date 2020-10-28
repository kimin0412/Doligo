package com.dolligo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.User;

@Repository
public interface IUserRepository extends JpaRepository<User, Integer>{
	@Query(value = "select * from user where email = ?1 ", nativeQuery = true)
    User getUserByEmail(String email);
    
	@Query(value = "select count(email) from user where email = ?1", nativeQuery = true)
	int isDupEmail(String email);
	
	//비밀번호 찾기
	@Query(value = "select count(id) from user where id = ?1 and password = ?2", nativeQuery = true)
	int checkPassword(String id, String password);
	
	@Query(value = "update user set password = ?2 where email = ?1", nativeQuery = true)
	void updatePasswordByEmail(String email, String password);
	
	@Query(value = "select password from user where id = ?1", nativeQuery = true)
	String selectPassword(int userId);

	
	

}

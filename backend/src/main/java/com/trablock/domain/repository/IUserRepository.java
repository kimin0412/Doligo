package com.trablock.domain.repository;

import java.util.List;

import org.mapstruct.Mapper;

import com.trablock.domain.User;

@Mapper
public interface IUserRepository {
    List<User> list();//전체 유저 리스트(유저 검색할때)
    
    
    User getUserById(long userid);
    User getUserByEmail(String email);
    
    long create(User user);
    int update(User user);
    int delete(String userid);

	int isDupEmail(String email);
	
	int checkPassword(String userId, String password);
	void updatePasswordByEmail(String email, String password);
	String selectPassword(String userId);
	
	long selectNextUserId();

}

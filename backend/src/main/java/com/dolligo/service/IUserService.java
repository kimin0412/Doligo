package com.dolligo.service;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.PointLog;
import com.dolligo.dto.User;

public interface IUserService {
    //id로유저 정보 가져옴
	@Transactional
	User getMyInfo(int id) throws Exception;//내 정보
	@Transactional
	User getUserInfo(String email) throws Exception;
    @Transactional
    User add(User user) throws Exception;//회원가입
    @Transactional
    User update(User user) throws Exception;//회원수정
    @Transactional
    void delete(String uid) throws Exception;//회원탈퇴
    
	boolean isDupEmail(String email) throws Exception;
	
	//비번 확인
	public boolean checkPassword(String uid, String password) throws Exception;
	public void sendTmpPasswordEmail(String password, String email) throws Exception;
	
	// 현금화 하기
	@Transactional
	PointLog makeCash(String uid, int amount);
	
	// 이제껏 받은 전단지 개수
	int getPaperCount(String uid);

}

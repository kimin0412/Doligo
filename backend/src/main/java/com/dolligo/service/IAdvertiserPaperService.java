package com.dolligo.service;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.User;

public interface IAdvertiserPaperService {
    //id로유저 정보 가져옴
	@Transactional
    User getUserInfo(long id) throws Exception;//남의 정보
	@Transactional
	User getMyInfo(long id) throws Exception;//내 정보
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

}

package com.dolligo.service;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.Advertiser;

public interface IAdvertiserService {
	@Transactional
	Advertiser getMyInfo(int id) throws Exception;//내 정보
	@Transactional
	Advertiser getAdvertiserInfo(String email) throws Exception;
//	@Transactional
//	Advertiser getMarketInfo(int id) throws Exception;
    @Transactional
    Advertiser add(Advertiser advertiser) throws Exception;//회원가입
    @Transactional
    Advertiser update(Advertiser advertiser) throws Exception;//회원수정
    
    @Transactional
    void delete(String uid) throws Exception;//회원탈퇴
    
	boolean isDupEmail(String email) throws Exception;
	
	//비번 확인
	public boolean checkPassword(String uid, String password) throws Exception;
	public void sendTmpPasswordEmail(String password, String email) throws Exception;

}

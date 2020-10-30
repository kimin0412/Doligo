package com.dolligo.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperstate;

public interface IUserPaperService {

	//포인트 적립 내역 확인
	List<Paperstate> getPointHistory(String uid);
	
	// 주변 전단지 목록 가져오기
	@Transactional
	List<Paper> getPaperList(String uid, String lat, String lon) throws Exception;
	
	// 전단지 상세보기
	Paper getPaperDetail(int pid);
	
	// 포인트 받기(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, qr인증)
	Paperstate getPoint(int pid, String uid, int state);//전단지 id, 상태값
	
	// 전단지 차단하기
	void blockPaper(int pid, String uid);
	
	// 차단한 가게 목록 확인
	List<Advertiser> getBlockList(String uid);
	
	// 쿠폰 저장하기
	void saveCoupon(String uid, Coupon coupon);
	
	// 쿠폰 목록 확인(아직 사용 안하고 유효한것만)
	List<Coupon> getCouponList(String uid);
	
	// 쿠폰 사용하기 => 가게 주인이 쿠폰 사용 버튼 대신 누름
	void useCoupon(String uid, int cid);
	
	//기프티콘 목록
	//기프티콘 상세
	//기프티콘 결제

}

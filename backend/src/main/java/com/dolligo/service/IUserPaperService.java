package com.dolligo.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.Block;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForList;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.PointLog;
import com.dolligo.dto.State;

public interface IUserPaperService {

	//포인트 적립 내역 확인
	List<PointLog> getPointHistory(String uid, int month);
	
	// 주변 전단지 목록 가져오기
	@Transactional
	List<PaperForList> getPaperList(String uid, String lat, String lon, int radius) throws Exception;
	
	// 전단지 상세보기
	Paper getPaperDetail(String uid, int pid);
	
	// 상태값 변경(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, qr인증, 차단)
	@Transactional
	Paperstate saveState(String uid, State state);//state : pid, 유저 성별, 유저 연령대, 유저 상태값
	
	// 차단한 가게 목록 확인
	List<Block> getBlockList(String uid);
	
	// 쿠폰 저장하기
	Coupon saveCoupon(String uid, int pid) throws Exception;
	
	// 쿠폰 목록 확인(아직 사용 안하고 유효한것만)
	List<Coupon> getCouponList(String uid);
	
	// 쿠폰 사용하기 => 가게 주인이 쿠폰 사용 버튼 대신 누름
	void useCoupon(String uid, int cid);

	// 차단 해제하기
	void cancelBlockPaper(String uid, int aid);

	// 푸시 알림 눌러서 포인트 받기
	void getPointByPush(String uid);
	
	//기프티콘 목록
	//기프티콘 상세
	//기프티콘 결제

}

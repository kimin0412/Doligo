package com.dolligo.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperstate;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.service.IUserPaperService;

@Service
public class UserPaperService implements IUserPaperService {

	@Autowired
	private IPaperRepository pRepo;
	
	@Autowired
	private IPaperStateRepository psRepo;
	

	//포인트 내역 가져오기
	@Override
	public List<Paperstate> getPointHistory(String uid) {
		return psRepo.findAllByUid(uid);
	}

	//주변 전단지 목록 가져오기
	@Override
	public List<Paper> getPaperList(String uid, String lat, String lon) throws Exception {
		/*
		 * paper 테이블에서 위도경도 범위 안에 있는 전단지 목록 다 가져옴
		 *  + 차단한 광고주의 전단지(pid) 제외
		 *  + 사용자가 이미 삭제한 전단지(pid) 제외
		 *  + 선호도 체크한 상권(mkid)의 전단지를 상단 배치 => order by..? 
		 */
		return null;
	}

	
	//paper + advertiser(어떤 가게인지도 알아야지)
	@Override
	public Paper getPaperDetail(int pid) {
		Optional<Paper> paper = pRepo.findById(pid);
		
		if(!paper.isPresent()) {
    		throw new NotFoundException(pid+"번 전단지 정보 찾지 못함");
    	}
		
		return paper.get();
	}

	@Override
	public Paperstate getPoint(int pid, String uid, int state) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void blockPaper(int pid, String uid) {
		
		
	}

	@Override
	public List<Advertiser> getBlockList(String uid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Coupon saveCoupon(String uid, int pid) {
		// TODO Auto-generated method stub
		return null;
		
	}

	@Override
	public List<Coupon> getCouponList(String uid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void useCoupon(String uid, int cid) {
		// TODO Auto-generated method stub
		
	}
	
}

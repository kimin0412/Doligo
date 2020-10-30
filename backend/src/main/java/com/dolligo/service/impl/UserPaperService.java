package com.dolligo.service.impl;

import java.util.List;

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
	

	@Override
	public List<Paperstate> getPointHistory(String uid) {
		return psRepo.findAllByUid(uid);
	}

	@Override
	public List<Paper> getPaperList(String uid, String lat, String lon) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Paper getPaperDetail(int pid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Paperstate getPoint(int pid, String uid, int state) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void blockPaper(int pid, String uid) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Advertiser> getBlockList(String uid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void saveCoupon(String uid, Coupon coupon) {
		// TODO Auto-generated method stub
		
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
	
//	@Override
//	public List<Paper> getPaperList() throws Exception {
//		List<Paper> papers = this.paperRepo.findAll();
//		if(papers.isEmpty()) {
//			throw new NotFoundException("근처에 등록된 전단지가 없습니다.");
//		}
//		
//		return papers;
//	}


}

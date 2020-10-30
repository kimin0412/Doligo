package com.dolligo.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Block;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperAnalysis;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.State;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserAnalysisRepository;
import com.dolligo.repository.IBlockRepository;
import com.dolligo.repository.ICouponRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.service.IUserPaperService;

@Service
public class UserPaperService implements IUserPaperService {

	@Autowired
	private IPaperRepository pRepo;
	@Autowired
	private IPaperStateRepository psRepo;
	@Autowired
	private IPaperAnalysisRepository paRepo;
	@Autowired
	private IAdvertiserAnalysisRepository aaRepo;
	
	@Autowired
	private IBlockRepository blockRepo;
	@Autowired
	private ICouponRepository cpRepo;
	

	// 포인트 내역 가져오기(paperstate + paper + advertiser) test
	@Override
	public List<Paperstate> getPointHistory(String uid) {
		return psRepo.findAllByUid(uid);
	}

	// 주변 전단지 목록 가져오기
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

	// 전단지 상세보기 paper + advertiser => paperstate, coupon도 가져와야 함(쿠폰 받았는지, 포인트 받았는지 확인) test
	@Override
	public Paper getPaperDetail(String uid, int pid) {
		Optional<Paper> p = pRepo.findById(pid);
		
		if(!p.isPresent()) {
    		throw new NotFoundException(pid+"번 전단지 정보 찾지 못함");
    	}
		Coupon c = cpRepo.findByPidAndUid(uid, pid);
		Paperstate ps = psRepo.findByUidAndPid(pid, uid);
		Paper paper = p.get();
		paper.setCoupon(c);
		if(ps != null) paper.setGetpoint(ps.isIsget());
//		
		return paper;
	}

	// 상태값 변경(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, qr인증, 차단)
	@Override
	public Paperstate saveState(String uid, State state) {
		int pid = state.getPid();
		
		Optional<Paper> tmp = pRepo.findById(state.getPid());
		if(!tmp.isPresent()) {
    		throw new NotFoundException("전단지 정보 찾지 못함");
    	}
		Paper paper = tmp.get();
		Paperstate ps = psRepo.findByUidAndPid(pid, uid);
		PaperAnalysis pa = paRepo.findByPid(pid);
		
		switch (state.getState()) {
		case 1://바로 삭제
			//paperstate 갱신 : state = 1(추가 포인트 지급 X)
			ps.setState(1);
			//paperAnalysis 갱신
			pa.setIgnore(pa.getIgnore() + 1);
			break;
		case 2://상세조회 포인트 얻기 버튼 클릭
			if(ps.isIsget()) {
				throw new ApplicationException("이미 포인트를 얻은 전단지입니다.");
			}
			//paperstate 갱신 : state = 2(추가 포인트 지급 O => 이미지 or 애니메이션 각자 다르게?), isget = true
			ps.setState(2);
			ps.setPoint(10);
			ps.setTotalpoint(ps.getTotalpoint() + 10);
			ps.setIsget(true);
			//paperAnalysis 갱신
			pa.setInterest(pa.getInterest() + 1);
			break;
			
		case 3://qr인증
			//paperstate 갱신 : state = 3(추가 포인트 지급 O), visited = true
			if(ps.isVisited()) {
				throw new ApplicationException("이미 방문 포인트를 얻은 전단지입니다.");
			}
			ps.setState(3);
			ps.setPoint(50);
			ps.setTotalpoint(ps.getTotalpoint() + 50);
			ps.setVisited(true);
			//paperAnalysis 갱신
			pa.setVisit(pa.getVisit() + 1);
			break;
			
		case 4://차단
			//paperstate 갱신 : state = 4(추가 포인트 지급 X)
			ps.setState(4);
			//paperAnalysis 갱신
			pa.setBlock(pa.getBlock() + 1);
			//block table 추가
			blockRepo.save(new Block(Integer.parseInt(uid), paper.getP_aid(), paper.getP_mtid()));
			break;
		}
		
		//paperstate 갱신
		psRepo.save(ps);
		//paperAnalysis 갱신
		paRepo.save(pa);
		//advertiserAnalysis 갱신
		aaRepo.save(new AdvertiserAnalysis(pid
										, paper.getP_mtid()
										, state.isGender()
										, state.getAge()
										, state.getState()));
		return ps;
	}

	// 차단한 가게 목록 확인 test
	@Override
	public List<Block> getBlockList(String uid) {
		List<Block> blocks = blockRepo.findAllByUid(uid);
		return blocks;
	}

	// 쿠폰 저장하기 test
	@Override
	public Coupon saveCoupon(String uid, int pid) {
		Coupon coupon = new Coupon(pid, Integer.parseInt(uid));
		cpRepo.save(coupon);
		return coupon;
	}

	// 쿠폰 목록 확인(아직 사용 안하고 유효한것만) test(같은 pid의 쿠폰이 있으면 paper, advertiser는 한번만 조인해서 가져옴..)
	@Override
	public List<Coupon> getCouponList(String uid) {
		List<Coupon> coupons = cpRepo.findAllByUid(uid);
		return coupons;
	}

	// 쿠폰 사용하기 => 가게 주인이 쿠폰 사용 버튼 대신 누름 test
	@Override
	public void useCoupon(String uid, int cid) {
		cpRepo.deleteById(cid);
	}
	
}

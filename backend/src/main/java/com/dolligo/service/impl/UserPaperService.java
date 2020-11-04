package com.dolligo.service.impl;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.dolligo.controller.UserController;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Block;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.PaperForList;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.Preference;
import com.dolligo.dto.State;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserAnalysisRepository;
import com.dolligo.repository.IBlockRepository;
import com.dolligo.repository.ICouponRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperForListRepository;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.repository.IPreferenceRepository;
import com.dolligo.service.IUserPaperService;

import java.util.Collections;
import java.util.Comparator;

@Service
public class UserPaperService implements IUserPaperService {
	public static final Logger logger = LoggerFactory.getLogger(UserController.class);
	public static final double R = 6372.8; // In kilometer
	
	@Autowired
	private IPaperRepository pRepo;
	@Autowired
	private IPaperStateRepository psRepo;
	@Autowired
	private IPaperAnalysisRepository paRepo;
	@Autowired
	private IAdvertiserAnalysisRepository aaRepo;
	@Autowired
	private IPreferenceRepository pfRepo;
	@Autowired
	private IPaperForListRepository plRepo;
	
	
	@Autowired
	private IBlockRepository blockRepo;
	@Autowired
	private ICouponRepository cpRepo;
	
	
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	//정각에cache db 갱신
	@Scheduled(cron = "0 * * * * *")//매일 정각에 수행(cron : "초 분 시 일 월 요일") 0 0 * * * *
	public void upadteCache() {
		LocalDateTime now = LocalDateTime.now();
		//현재 시간에 유효한 광고 목록 가져옴
		List<PaperForList> validPapers = plRepo.findallByTime(now);
//		for(PaperForList p : validPapers) System.out.println(p);
		if(validPapers == null) {
			logger.info("valid paper is null");
			return;
		}
		String timeKey = Integer.toString(now.getHour());
		//redis에 갱신(현재 시간 row에 유효한 광고 목록 넣음)
		redisTemplate.opsForValue().set(timeKey, validPapers);
		redisTemplate.expire(timeKey, 1, TimeUnit.MINUTES);//1시간 후 만료 Hours
		
		logger.info(timeKey+"H : valid paper data update in redis");
	}
	

	// 포인트 내역 가져오기(paperstate + paper + advertiser) test
	@Override
	public List<Paperstate> getPointHistory(String uid) {
		return psRepo.findAllByUid(uid);
	}

	// 주변 전단지 목록 가져오기(내 위치 위도, 경도, 반경(m))
	@Override
	public List<PaperForList> getPaperList(String uid, String lat, String lon, int radius) throws Exception {
		// 1. 현재 시간 가져와서 현재 시간에 유효한 전단지 리스트 redis에서 꺼내옴
		Object tmp = redisTemplate.opsForValue().get(Integer.toString(LocalTime.now().getHour()));
		if(tmp == null) return null;
		List<PaperForList> papers = (List<PaperForList>) tmp;
//		for(PaperForList p : papers) System.out.println(p);
		
		// 2. 가져온 데이터 중 범위 벗어나는 전단지 & 차단한 광고주의 전단지 & 삭제한 전단지 제외
		List<Block> blocks = blockRepo.findAllByUid(uid);//차단 목록
		List<Integer> blockAid = new ArrayList<Integer>();
		
		// 3. uid로 나의 상권 preference 정보(order by mid) 가져와 내 전단지 리스트와 비교하면서 isprefer 가중치 값 paper 객체에 저장
		List<Preference> prefers = pfRepo.findAllByUid(uid);
		int preferIdx = 0;
		
		for(Block b : blocks) {
			blockAid.add(b.getAid());
		}
		for(int i = 0; i < papers.size(); i++) {
			PaperForList p = papers.get(i);
			
			//반경 안에 포함 안되면 삭제
			if(!isIncluded(p, Double.parseDouble(lat), Double.parseDouble(lon), radius)) {
				papers.remove(i--);
				continue;
			}
			
			//차단한 광고주 전단지 삭제
			if(blockAid.contains(p.getP_aid())) {
				papers.remove(i--);
				continue;
			}
			
			Paperstate ps = psRepo.findByUidAndPid(p.getP_id(), uid);
			if(ps == null) {//처음 받는 전단지
				p.setFirst(true);
				//Paperstate 객체 생성
				ps = new Paperstate();
				ps.setUid(Integer.parseInt(uid));
				ps.setPid(p.getP_id());
				psRepo.saveAndFlush(ps);
				//뿌린 전단지 숫자 ++
				Paperanalysis pa = paRepo.findByPid(p.getP_id());
				pa.setDistributed(pa.getDistributed() + 1);
				paRepo.saveAndFlush(pa);
			} else if(ps.getState() == 1) {//사용자가 이미 삭제한 전단지 삭제 => uid, pid로 paperstate 검색 후 state = 1이면 삭제한 기록
				papers.remove(i--);
				continue;
			}
			
			//isprefer 가중치 값 찾아서 p의 prefer 값 갱신(prefers는 mid 오름차순 정렬 되어있음)
			while(!prefers.isEmpty() && true) {
				Preference pf = prefers.get(preferIdx);
				if(pf.getMid() == p.getP_mtid()) {//같은 상권정보 찾으면 선호도 값 복사
					p.setPrefer(pf.getIsprefer());
					break;
				}else {
					preferIdx++;
				}
			}
//			System.out.println(p);
		}
		
		// 4. isperfer 내림차순으로 정렬한 후 return(만약 같다면 뿌리는 위치도 비교해야함,,,)
		Collections.sort(papers);
		return papers;
	}

	//반경 안에 포함 되는지 확인
	private boolean isIncluded(PaperForList paper, double lat, double lon, int radius) {
		
		double lat2 = Double.parseDouble(paper.getLat());
		double lon2 = Double.parseDouble(paper.getLon());
		double dLat = Math.toRadians(lat - lat2);
		double dLon = Math.toRadians(lon - lon2);
		
		lat = Math.toRadians(lat);
		lat2 = Math.toRadians(lat2);
		
		double a = Math.pow(Math.sin(dLat / 2), 2) + Math.pow(Math.sin(dLon / 2), 2)
					* Math.cos(lat) * Math.cos(lat2);
		double c = 2 * Math.asin(Math.sqrt(a));
		

		//R * c * 1000 : 두 지점 사이의 거리 (단위 : m)
		if(R * c * 1000 <= radius) {
			paper.setDistance(R*c*1000);
			return true;
		}
		else return false;
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

		return paper;
	}

	// 상태값 변경(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, -qr인증-, 차단)
	@Override
	public Paperstate saveState(String uid, State state) {
		int pid = state.getPid();
		
		Optional<Paper> tmp = pRepo.findById(state.getPid());
		if(!tmp.isPresent()) {
    		throw new NotFoundException(pid+"번 전단지 정보 찾지 못함");
    	}
		Paper paper = tmp.get();
		Paperstate ps = psRepo.findByUidAndPid(pid, uid);
		Paperanalysis pa = paRepo.findByPid(pid);
		Preference pf = pfRepo.findByUidAndMid(uid, paper.getP_mtid());
		if(pf == null) {//해당 markettype에 대한 선호도 정보가 없는 상태
			pf = new Preference(Integer.parseInt(uid), paper.getP_mtid(), 0);
		}
		
		switch (state.getState()) {
		case 1://바로 삭제
			//paperstate 갱신 : state = 1(추가 포인트 지급 X)
			ps.setState(1);
			//paperAnalysis 갱신
			pa.setDisregard(pa.getDisregard() + 1);
			//preference 가중치 -1
			pf.setIsprefer(pf.getIsprefer() - 1);
			break;
		case 2://상세조회 포인트 얻기 버튼 클릭
			if(ps.isIsget()) {
				throw new ApplicationException("이미 포인트를 얻은 전단지입니다.");
			}
			//paperstate 갱신 : state = 2(추가 포인트 지급 O => 이미지 or 애니메이션 각자 다르게?), isget = true
			ps.setState(2);
			ps.setPoint(paper.getP_point());
			ps.setTotalpoint(ps.getTotalpoint() + paper.getP_point());
			ps.setIsget(true);
			//paperAnalysis 갱신
			pa.setInterest(pa.getInterest() + 1);
			//preference 가중치 +1
			pf.setIsprefer(pf.getIsprefer() + 1);
			break;
			
			/*
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
			//preference 가중치 +1
			pf.setIsprefer(pf.getIsprefer() + 1);
			break;
			*/
		case 4://차단
			//paperstate 갱신 : state = 4(추가 포인트 지급 X)
			ps.setState(4);
			//paperAnalysis 갱신
			pa.setBlock(pa.getBlock() + 1);
			//preference 가중치 -1
			pf.setIsprefer(pf.getIsprefer() - 1);
			//block table 추가
			blockRepo.save(new Block(Integer.parseInt(uid), paper.getP_aid(), paper.getP_mtid()));
			break;
		}
		
		//paperstate 갱신
		psRepo.save(ps);
		//paperAnalysis 갱신
		paRepo.save(pa);
		//preference 갱신
		pfRepo.save(pf);
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

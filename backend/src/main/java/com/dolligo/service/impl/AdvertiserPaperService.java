package com.dolligo.service.impl;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.controller.AdvertiserPaperController;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.CircleAge;
import com.dolligo.dto.CircleGender;
import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForPost;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.PointLog;
import com.dolligo.dto.Preference;
import com.dolligo.dto.State;
import com.dolligo.dto.TimeGraph;
import com.dolligo.dto.User;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.BadRequestException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserAnalysisRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperForPostRepository;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.repository.IPointLogRepository;
import com.dolligo.repository.IPreferenceRepository;
import com.dolligo.repository.ITimeGraphRepository;
import com.dolligo.repository.IUserRepository;
import com.dolligo.service.IAdvertiserPaperService;

@Service
public class AdvertiserPaperService implements IAdvertiserPaperService {
	public static final Logger logger = LoggerFactory.getLogger(AdvertiserPaperController.class);

//	@Autowired
//	private IAdvertiserAnalysisRepository adanRepo;

	@Autowired
	private IPaperRepository pRepo;
	@Autowired
	private IUserRepository uRepo;
	@Autowired
	private IPaperAnalysisRepository paRepo;
	@Autowired
	private IPaperStateRepository psRepo;
	@Autowired
	private IAdvertiserAnalysisRepository aaRepo;
	@Autowired
	private ITimeGraphRepository tgRepo;
    @Autowired
	private IPreferenceRepository pfRepo;
	@Autowired
	private IPaperForPostRepository pfpRepo;
	@Autowired
	private IPointLogRepository pointRepo;
	
	@Override
	public Paperanalysis getRecentAnalysis(int aid) {
		Paper p = pRepo.getRecentPaper(aid);
		System.out.println(p.toString());
		System.out.println(p.getP_id());
		Paperanalysis opa = paRepo.findByPid(p.getP_id());

		if (opa == null) {
			throw new NotFoundException(aid + " 번 광고주의 통계를 찾지 못함");
		}
		return opa;
	}

	@Override
	public List<AdvertiserAnalysis> getAllAdvertiserAnalysis(int aid) {
		List<AdvertiserAnalysis> aa = aaRepo.getAllAdvertiserAnalysis(aid);
		if (aa.isEmpty()) {
			throw new NotFoundException(aid + " 번 광고주 별 분석 통계를 찾지 못함");
		}
		return aa;
	}

	@Override
	public List<TimeGraph> getTimeTable(int aid) {
		List<TimeGraph> tgList = new ArrayList<>();
		for (int i = 0; i < 24; i++) {
			String start = "0" + i + ":00:00";
			String end = "0" + (i+1) + ":00:00";
			
			TimeGraph tg = tgRepo.getTimeCnt(aid, start, end);
			tgList.add(tg);
		}
		return tgList;
	}

	@Override
	public CircleAge getCircleAge(int aid) {
		List<AdvertiserAnalysis> aa = aaRepo.getAllAdvertiserAnalysis(aid);
		if (aa.isEmpty()) {
			throw new NotFoundException(aid + " 번 광고주 별 분석 통계를 찾지 못함");
		}

		Calendar calendar = Calendar.getInstance();
		int CurrYear = calendar.get(Calendar.YEAR);
		CircleAge ca = new CircleAge();

		for (AdvertiserAnalysis a : aa) {
			int age = CurrYear - a.getAge() + 1;
			
			if (10 <= age && age < 20)
				ca.setTeen(ca.getTeen() + 1);
			if (20 <= age && age < 30)
				ca.setSecond(ca.getSecond() + 1);
			if (30 <= age && age < 40)
				ca.setThird(ca.getThird() + 1);
			if (40 <= age && age < 50)
				ca.setForth(ca.getForth() + 1);
			if (50 <= age)
				ca.setAbove(ca.getAbove() + 1);
		}
		return ca;
	}

	@Override
	public CircleGender getCircleGender(int aid) {
		int mCnt = aaRepo.getGenderMan(aid);
		int wCnt = aaRepo.getGenderWoman(aid);
		int allCnt = aaRepo.getAllAdvertiserAnalysis(aid).size();

		CircleGender cg = new CircleGender();
		cg.setM(mCnt);
		cg.setW(wCnt);
		cg.setA(allCnt);

		return cg;
	}

	@Override
	public List<Paperanalysis> getAllAnalysis(String aid) {
		List<Paperanalysis> paperAnalysisList = paRepo.findAllByAid(aid);

		return paperAnalysisList;
	}

	@Override
	public Paper getPaperDetail(String aid, int pid) {
		Paper paper = pRepo.findByPid(aid, pid);

		if (paper == null) {
			throw new NotFoundException(pid + "번 전단지 찾지 못함");
		}
		return paper;
	}

	@Override
	public List<Paper> getAllPaper(String aid) {
		List<Paper> paperList = pRepo.findAllByP_aid(aid);
		return paperList;
	}

	@Override
	public void insertPaper(PaperForPost paper) {
		paper.setP_point(15); // 상세조회 시 얻는 포인트 양
		pfpRepo.save(paper);
		
		Paperanalysis pa = new Paperanalysis();
		pa.setPid(paper.getP_id());
		paRepo.save(pa);
	}

	@Override
	public void authQrcode(String aid, State state) throws BadRequestException {
		
		int pid = state.getPid();
		String uid = Integer.toString(state.getUid());
		User user = uRepo.findById(state.getUid()).get();
		
		Optional<Paper> tmp = pRepo.findById(state.getPid());
		if(!tmp.isPresent()) {
    		throw new NotFoundException(pid+"번 전단지 정보 찾지 못함");
    	}
		
		if(pRepo.findByAidAndPid(aid, pid) == 0) {
			throw new BadRequestException("내가 등록한 전단지 아님");
		}
		
		Paper paper = tmp.get();
		Paperstate ps = psRepo.findByUidAndPid(pid, uid);
		Paperanalysis pa = paRepo.findByPid(pid);
		Preference pf = pfRepo.findByUidAndMid(uid, paper.getP_mtid());
		if(pf == null) {//해당 markettype에 대한 선호도 정보가 없는 상태
			pf = new Preference(Integer.parseInt(uid), paper.getP_mtid(), 0);
		}
		
		if(ps.isVisited()) {
			throw new ApplicationException("이미 방문 포인트를 얻은 전단지입니다.");
		}
		ps.setState(3);
//		ps.setPoint(50);
//		ps.setTotalpoint(ps.getTotalpoint() + 50);
		ps.setVisited(true);
		
		user.setPoint(user.getPoint() + 50);//방문 포인트 ++
		uRepo.save(user);
		
		//포인트 내역 추가
		PointLog pl = new PointLog();
		pl.setDescription("방문 포인트");
		pl.setPoint(50);
		pl.setTotalPoint(user.getPoint());
		pl.setSid(1);//전단지로 포인트 얻음
		pl.setSource(paper.getP_id());
		pl.setUid(Integer.parseInt(uid));
		pointRepo.save(pl);
		
		
		//paperAnalysis 갱신
		pa.setVisit(pa.getVisit() + 1);
		//preference 가중치 +1
		pf.setIsprefer(pf.getIsprefer() + 1);
		
		
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
		
//		AdvertiserAnalysis aaa = new AdvertiserAnalysis();
//		aaa.setAid(paper.getP_aid());
//		aaa.setMtid(paper.getP_mtid());
//		aaa.setGender(state.isGender());
//		aaa.setAge(state.getAge());
//		aaa.setState(state.getState());
//		aaa.setTime(LocalDateTime.of(2020,11,6, 23,10,00));
//		aaRepo.save(aaa);
	}

}

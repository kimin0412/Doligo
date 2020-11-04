package com.dolligo.service.impl;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.controller.AdvertiserPaperController;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.Preference;
import com.dolligo.dto.State;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.BadRequestException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserAnalysisRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperForPostRepository;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.repository.IPreferenceRepository;
import com.dolligo.service.IAdvertiserPaperService;

@Service
public class AdvertiserPaperService implements IAdvertiserPaperService {
	public static final Logger logger = LoggerFactory.getLogger(AdvertiserPaperController.class);
	
	@Autowired
	private IAdvertiserAnalysisRepository adanRepo;
	
	@Autowired
	private IPaperRepository pRepo;
	@Autowired
	private IPaperAnalysisRepository paRepo;
	@Autowired
	private IPaperStateRepository psRepo;
	@Autowired
	private IAdvertiserAnalysisRepository aaRepo;
	@Autowired
	private IPreferenceRepository pfRepo;
	
	@Override
	public Paperanalysis getRecentAnalysis(int aid) {
		Paper p = pRepo.getRecentPaper(aid);
		System.out.println(p.toString());
		System.out.println(p.getP_id());
		Paperanalysis opa = paRepo.findByPid(p.getP_id());
		
		if(opa == null) {
			throw new NotFoundException(aid + "번 광고주의 통계를 찾지 못함");
		}
		return opa;
	}

	@Override
	public List<Paperanalysis> getAllAnalysis(String aid) {
		List<Paperanalysis> paperAnalysisList = paRepo.findAllByAid(aid);
		
		
		return paperAnalysisList;
	}

	@Override
	public Paper getPaperDetail(String aid, int pid) {
		Paper paper = pRepo.findByPid(aid, pid);
		
		if(paper == null) {
			throw new NotFoundException(pid+"번 전단지 찾지 못함");
		}
		return paper;
	}

	@Override
	public List<Paper> getAllPaper(String aid) {
		List<Paper> paperList = pRepo.findAllByP_aid(aid);
		return paperList;
	}

	@Override
	public void insertPaper(Paper paper) {
		pRepo.save(paper);
	}

	@Override
	public void authQrcode(String aid, State state) throws BadRequestException {
		
		int pid = state.getPid();
		String uid = Integer.toString(state.getUid());
		
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
		ps.setPoint(50);
		ps.setTotalpoint(ps.getTotalpoint() + 50);
		ps.setVisited(true);
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
		
	}

}

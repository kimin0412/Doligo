package com.dolligo.service.impl;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.controller.AdvertiserPaperController;
import com.dolligo.controller.UserController;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.CircleAge;
import com.dolligo.dto.CircleGender;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.TimeGraph;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserAnalysisRepository;
import com.dolligo.repository.IAdvertiserRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperRepository;
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
	private IAdvertiserAnalysisRepository aaRepo;
	
	@Override
	public Paperanalysis getRecentAnalysis(int aid) {
		Paper p = pRepo.getRecentPaper(aid);
		System.out.println(p.toString());
		System.out.println(p.getP_id());
		Paperanalysis opa = paRepo.findByPid(p.getP_id());
		
		if(opa == null) {
			throw new NotFoundException(aid + " 번 광고주의 통계를 찾지 못함");
		}
		return opa;
	}
	
	@Override
	public List<AdvertiserAnalysis> getAllAdvertiserAnalysis(int aid){
		List<AdvertiserAnalysis> aa = aaRepo.getAllAdvertiserAnalysis(aid);
		if(aa.isEmpty()) {
			throw new NotFoundException(aid + " 번 광고주 별 분석 통계를 찾지 못함");
		}
		return aa;
	}

	@Override
	public TimeGraph getTimeTable(int aid) {
		List<AdvertiserAnalysis> aa = aaRepo.getAllAdvertiserAnalysis(aid);
		if(aa.isEmpty()) {
			throw new NotFoundException(aid + " 번 광고주 별 분석 통계를 찾지 못함");
		}
		
		for (AdvertiserAnalysis a : aa) {
			System.out.println(a.getTime());
//			if(a.getTime())
		}
		return null;
	}

	@Override
	public CircleAge getCircleAge(int aid) {
		int mCnt = aaRepo.getGenderMan(aid);
		int wCnt = aaRepo.getGenderWoman(aid);
		int allCnt = aaRepo.getAllAdvertiserAnalysis(aid).size();
		
		CircleAge ca = new CircleAge();
//		cg.setM(mCnt);
//		cg.setW(wCnt);
//		cg.setA(allCnt);
		
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

}

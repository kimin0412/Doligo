package com.dolligo.service.impl;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.datetime.joda.LocalDateTimeParser;
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
import com.dolligo.repository.ITimeGraphRepository;
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
	@Autowired
	private ITimeGraphRepository tgRepo;

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
	public void insertPaper(Paper paper) {
		pRepo.save(paper);
	}

}

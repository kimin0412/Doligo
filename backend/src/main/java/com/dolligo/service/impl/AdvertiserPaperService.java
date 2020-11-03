package com.dolligo.service.impl;

import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.controller.AdvertiserPaperController;
import com.dolligo.controller.UserController;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
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

}

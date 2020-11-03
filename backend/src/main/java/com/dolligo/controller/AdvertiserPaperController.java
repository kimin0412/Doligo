package com.dolligo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.exception.BadRequestException;
import com.dolligo.service.IAdvertiserPaperService;
import com.dolligo.service.IJwtService;

import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/token/advertiser")
public class AdvertiserPaperController {
	public static final Logger logger = LoggerFactory.getLogger(AdvertiserPaperController.class);

	@Autowired
	private IJwtService jwtService;

	private IAdvertiserPaperService apaperService;

//	private IApa
	
	@Autowired
	public AdvertiserPaperController(IAdvertiserPaperService apaperService) {
		Assert.notNull(apaperService, "advertiserPaperService 개체가 반드시 필요!");
		this.apaperService = apaperService;
	}

	// 최근 전단지 통계 가져오기
	@ApiOperation(value = "최근 전단지 통계 가져오기")
	@GetMapping("/statistic/recent")
	public ResponseEntity<HashMap<String, Object>> getRecentStatistic(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));

//		Map<String, Object> claims = jwtService.get(token);
//  		String id = (String)claims.get("id");
  		System.out.println(aid);
		Paperanalysis pa = apaperService.getRecentAnalysis(Integer.parseInt(aid));
		map.put("data", pa);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	private String getAid(String auth) {
		String token = auth.split(" ")[1];

		Map<String, Object> claims = jwtService.get(token);
		return (String) claims.get("uid");
	}
	
	// 이제까지 전단지 통계 내역(paper + paperanalysis)
	@ApiOperation(value = "등록한 전단지 통계 내역 가져오기")
	@GetMapping("paper/statistic")
	public ResponseEntity<HashMap<String, Object>> getAllStatistic(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));
		
		List<Paperanalysis> paList = apaperService.getAllAnalysis(aid);
		map.put("data", paList);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	// 이제까지 전단지 내역(paper)
	@ApiOperation(value = "등록한 전단지 내역 가져오기")
	@GetMapping("paper")
	public ResponseEntity<HashMap<String, Object>> getAllPaper(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));
		
		List<Paper> pList = apaperService.getAllPaper(aid);
		map.put("data", pList);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	// 전단지 상세 내역(paper)
	@ApiOperation(value = "등록한 전단지 상세 내역 가져오기")
	@GetMapping("paper/{paper_id}")
	public ResponseEntity<HashMap<String, Object>> getPaperByPid(@PathVariable("paper_id") int pid
																, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String aid = getAid(request.getHeader("Authorization"));
		
		Paper paper = apaperService.getPaperDetail(aid, pid);
		
		map.put("data", paper);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	// 전단지 등록하기
	@ApiOperation(value = "새로운 전단지 등록하기")
	@PostMapping("paper")
	public ResponseEntity<HashMap<String, Object>> makeNewPaper(@RequestBody Paper paper, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String aid = getAid(request.getHeader("Authorization"));
		
		if(paper.getP_aid() != Integer.parseInt(aid)) {
			throw new BadRequestException("내 전단지만 등록 가능");
		}
		apaperService.insertPaper(paper);
		
		map.put("data", paper);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
}

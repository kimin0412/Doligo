package com.dolligo.controller;

import java.util.ArrayList;
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

import com.dolligo.dto.CircleAge;
import com.dolligo.dto.CircleGender;
import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForPost;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.State;
import com.dolligo.dto.TimeGraph;
import com.dolligo.exception.BadRequestException;
import com.dolligo.service.IAdvertiserPaperService;
import com.dolligo.service.IJwtService;

import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/token/advertiser/paper")
public class AdvertiserPaperController {
	public static final Logger logger = LoggerFactory.getLogger(AdvertiserPaperController.class);

	@Autowired
	private IJwtService jwtService;

	private IAdvertiserPaperService apaperService;

	@Autowired
	public AdvertiserPaperController(IAdvertiserPaperService apaperService) {
		Assert.notNull(apaperService, "advertiserPaperService 개체가 반드시 필요!");
		this.apaperService = apaperService;
	}

	// 최근 전단지 통계 가져오기
	@ApiOperation(value = "대시보드 통계 가져오기")
	@GetMapping("/dashboard")
	public ResponseEntity<HashMap<String, Object>> getRecentStatistic(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));
		
		Paperanalysis pa = apaperService.getRecentAnalysis(Integer.parseInt(aid));
		map.put("recent", pa);
		
		CircleGender cg = apaperService.getCircleGender(Integer.parseInt(aid));
		CircleAge ca = apaperService.getCircleAge(Integer.parseInt(aid));
		map.put("cg", cg);
		map.put("ca", ca);

		List<TimeGraph> tg = new ArrayList<>();
		tg = apaperService.getTimeTable(Integer.parseInt(aid));
		map.put("tg", tg);
		
		apaperService.getTimeTable(Integer.parseInt(aid));
		
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	private String getAid(String auth) {
		String token = auth.split(" ")[1];

		Map<String, Object> claims = jwtService.get(token);
		return (String) claims.get("uid");
	}
	
	// 이제까지 전단지 통계 내역(paper + paperanalysis)
	@ApiOperation(value = "등록한 전단지 통계 내역 가져오기")
	@GetMapping("/statistic")
	public ResponseEntity<HashMap<String, Object>> getAllStatistic(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));
		
		List<Paperanalysis> paList = apaperService.getAllAnalysis(aid);
		for (Paperanalysis p : paList) {
			System.out.println(p.toString());
		}
		map.put("data", paList);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	// 이제까지 전단지 내역(paper)
	@ApiOperation(value = "등록한 전단지 내역 가져오기")
	@GetMapping("")
	public ResponseEntity<HashMap<String, Object>> getAllPaper(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String aid = getAid(request.getHeader("Authorization"));
		
		List<Paper> pList = apaperService.getAllPaper(aid);
		map.put("data", pList);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	// 전단지 상세 내역(paper)
	@ApiOperation(value = "등록한 전단지 상세 내역 가져오기")
	@GetMapping("/{paper_id}")
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
	@PostMapping("")
	public ResponseEntity<HashMap<String, Object>> makeNewPaper(@RequestBody PaperForPost paper, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String aid = getAid(request.getHeader("Authorization"));
//		paper.setP_aid(Integer.parseInt(aid));
		if(paper.getP_aid() != Integer.parseInt(aid)) {
			throw new BadRequestException("내 전단지만 등록 가능");
		}
		apaperService.insertPaper(paper);
		
		map.put("data", paper);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	// 광고주 qr인증
	@ApiOperation(value = "qr인증하기", notes = "변수 state값은 넣을 필요 X && 성별 여자 : true, 남자 : false")
	@PostMapping("qrcode")
	public ResponseEntity<HashMap<String, Object>> authQrcode(@RequestBody State state, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		//pid, uid 가져왔는데 해당 pid가 aid가 만든 전단지가 아니라면 
		
		String aid = getAid(request.getHeader("Authorization"));
		apaperService.authQrcode(aid, state);
		
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	
}

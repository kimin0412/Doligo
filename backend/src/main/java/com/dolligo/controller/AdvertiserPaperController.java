package com.dolligo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Login;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.TempKey;
import com.dolligo.dto.User;
import com.dolligo.exception.BadRequestException;
import com.dolligo.exception.EmptyListException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.service.IAdvertiserPaperService;
import com.dolligo.service.IJwtService;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

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
}

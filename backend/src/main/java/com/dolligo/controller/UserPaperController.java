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

import com.dolligo.dto.Login;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.TempKey;
import com.dolligo.dto.User;
import com.dolligo.exception.BadRequestException;
import com.dolligo.exception.EmptyListException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.service.IJwtService;
import com.dolligo.service.IUserPaperService;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/token/user")
public class UserPaperController {
	public static final Logger logger = LoggerFactory.getLogger(UserPaperController.class);

	@Autowired
    private IJwtService jwtService;
	
	private IUserPaperService upaperService;

	@Autowired
	public UserPaperController(IUserPaperService upaperService) {
		Assert.notNull(upaperService, "userPaperService 개체가 반드시 필요!");
		this.upaperService = upaperService;
	}
	
	
	// 포인트 적립 내역 확인
	@ApiOperation(value = "포인트 적립 내역 확인")
	@GetMapping("/point")
	public ResponseEntity<HashMap<String, Object>> getPointHistory(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		
		
		List<Paperstate> pointHistory = upaperService.getPointHistory(uid);
		
		map.put("data", pointHistory);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	// 주변 전단지 목록 가져오기
	// 전단지 상세보기
	// 포인트 받기(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, qr인증)
	// 전단지 차단하기
	// 차단한 가게 목록 확인
	// 쿠폰 저장하기
	// 쿠폰 목록 확인
	// 쿠폰 사용하기 => 가게 주인이 쿠폰 사용 버튼 대신 누름


	private String getUid(String auth) {
		String token = auth.split(" ")[1];
		
  		Map<String, Object> claims = jwtService.get(token);
  		return (String)claims.get("uid");
	}
	
	
	//기프티콘 목록
	//기프티콘 상세
	//기프티콘 결제

//	@ApiOperation(value = "모든 전단지 가져오기")
//	@GetMapping("/paper")
//	public List<Paper> getAllPaper() throws Exception {
//		List<Paper> papers = upaperService.getPaperList();
//		return papers;
//	}
}

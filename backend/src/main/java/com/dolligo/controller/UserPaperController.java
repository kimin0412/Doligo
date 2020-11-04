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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dolligo.dto.Block;
import com.dolligo.dto.Coupon;
import com.dolligo.dto.Paper;
import com.dolligo.dto.PaperForList;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.State;
import com.dolligo.service.IJwtService;
import com.dolligo.service.IUserPaperService;

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
	
	
	// 포인트 적립 내역 확인 test
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
	@ApiOperation(value = "주변 전단지 목록 가져오기")
	@GetMapping("/paper/{lat}/{lon}/{radius}")
	public ResponseEntity<HashMap<String, Object>> getPaperList(@PathVariable("lat") String lat
																, @PathVariable("lon") String lon
																, @PathVariable("radius") int radius
																, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		//가져온 전단지의 목록만큼 paperstate 만들어서 받은만큼 포인트++ 시켜줘야함
		
		String uid = getUid(request.getHeader("Authorization"));
		
		List<PaperForList> papers = upaperService.getPaperList(uid, lat, lon, radius);
		
		map.put("data", papers);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	// 전단지 상세보기 test
	@ApiOperation(value = "전단지 상세보기")
	@GetMapping("/paper/{paper_id}")
	public ResponseEntity<HashMap<String, Object>> getPaperDetail(@PathVariable("paper_id") int pid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		Paper paper = upaperService.getPaperDetail(uid, pid);
		
		map.put("data", paper);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	
	// 상태값 변경(바로 삭제, 상세 조회 후 포인트받기 버튼 클릭, qr인증, 차단)
	@ApiOperation(value = "상태값 변경 + 포인트 얻기(state => 1 : 바로 삭제, 2 : 상세 조회 페이지에서 포인트받기 버튼 클릭, 4 : 차단)"
			, notes = "state 정보로 uid값은 넣을 필요 X")
	@PostMapping("/state")
	public ResponseEntity<HashMap<String, Object>> saveState(@RequestBody State state, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		
		
		Paperstate ps = upaperService.saveState(uid, state);
		
		map.put("data", ps);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	
//	// 전단지 차단하기
//	@ApiOperation(value = "전단지 차단하기 => 광고주를 차단")
//	@PostMapping("/block")
//	public ResponseEntity<HashMap<String, Object>> blockPaper(@RequestBody State state, HttpServletRequest request) throws Exception {
//		HashMap<String, Object> map = new HashMap<String, Object>();
//		
//		String uid = getUid(request.getHeader("Authorization"));
//		
//		upaperService.blockPaper(uid, state);
//		
//  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
//	}
	
	
	// 차단한 가게 목록 확인 test
	@ApiOperation(value = "차단한 가게 목록 확인")
	@GetMapping("/block")
	public ResponseEntity<HashMap<String, Object>> getBlockList(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		
		
		List<Block> ads = upaperService.getBlockList(uid);
		
		map.put("data", ads);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	// 쿠폰 저장하기 test
	@ApiOperation(value = "쿠폰 저장하기")
	@PostMapping("/coupon/{paper_id}")
	public ResponseEntity<HashMap<String, Object>> saveCoupon(@PathVariable("paper_id") int pid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		
		Coupon coupon = upaperService.saveCoupon(uid, pid);
		
		map.put("data", coupon);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	
	// 쿠폰 목록 확인
	@ApiOperation(value = "쿠폰 목록 확인(아직 사용 안하고 유효한것만)")
	@GetMapping("/coupon")
	public ResponseEntity<HashMap<String, Object>> getCouponList(HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		//조회 하고 기한 지난거는 삭제 처리
		String uid = getUid(request.getHeader("Authorization"));
		
		List<Coupon> coupons = upaperService.getCouponList(uid);
		
		map.put("data", coupons);
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	
	// 쿠폰 사용하기 => 가게 주인이 쿠폰 사용 버튼 대신 누름
	@ApiOperation(value = "쿠폰 사용하기")
	@DeleteMapping("/coupon/{coupon_id}")
	public ResponseEntity<HashMap<String, Object>> useCoupon(@PathVariable("coupon_id") int cid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		
		upaperService.useCoupon(uid, cid);
		
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	//기프티콘 목록
	//기프티콘 상세
	//기프티콘 결제

	
	private String getUid(String auth) {
		String token = auth.split(" ")[1];
		
  		Map<String, Object> claims = jwtService.get(token);
  		return (String)claims.get("uid");
	}

}

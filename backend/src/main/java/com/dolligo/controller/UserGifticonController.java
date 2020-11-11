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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dolligo.dto.Gifticon;
import com.dolligo.dto.PointLog;
import com.dolligo.service.IJwtService;
import com.dolligo.service.IUserGifticonService;

import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/token/gifticon")
public class UserGifticonController {
	public static final Logger logger = LoggerFactory.getLogger(UserGifticonController.class);

	@Autowired
    private IJwtService jwtService;
	
	private IUserGifticonService uGiftService;

	@Autowired
	public UserGifticonController(IUserGifticonService uGiftService) {
		Assert.notNull(uGiftService, "uGiftService 개체가 반드시 필요!");
		this.uGiftService = uGiftService;
	}
	
	
	//아직 구매 안된 기프티콘 목록 조회(카테고리별)
	@ApiOperation(value = "아직 구매 안된 기프티콘 목록 조회(카테고리별)")
	@GetMapping("/{category_id}")
	public ResponseEntity<HashMap<String, Object>> getAllGifticons(@PathVariable("category_id") int cid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		List<Gifticon> gifticons = uGiftService.getAllGifticons(cid);
		
		map.put("data", gifticons);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	//기프티콘 상세 조회
	@ApiOperation(value = "기프티콘 상세 조회")
	@GetMapping("detail/{gifticon_id}")
	public ResponseEntity<HashMap<String, Object>> getGifticon(@PathVariable("gifticon_id") int gid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Gifticon gifticon = uGiftService.getGifticon(gid);
		
		map.put("data", gifticon);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}
	
	//기프티콘 구매
	@ApiOperation(value = "기프티콘 구매")
	@PostMapping("/{gifticon_id}")
	public ResponseEntity<HashMap<String, Object>> purchaseGifticon(@PathVariable("gifticon_id") int gid, HttpServletRequest request) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String uid = getUid(request.getHeader("Authorization"));
		PointLog pl = uGiftService.purchaseGifticon(uid, gid);
		
		map.put("data", pl);
		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
	}

	private String getUid(String auth) {
		String token = auth.split(" ")[1];
		
  		Map<String, Object> claims = jwtService.get(token);
  		return (String)claims.get("uid");
	}
}

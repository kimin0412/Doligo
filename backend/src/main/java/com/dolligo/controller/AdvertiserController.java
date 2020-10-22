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
import com.dolligo.dto.TempKey;
import com.dolligo.dto.User;
import com.dolligo.exception.BadRequestException;
import com.dolligo.exception.EmptyListException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.service.IJwtService;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api")
public class AdvertiserController {
    public static final Logger logger = LoggerFactory.getLogger(AdvertiserController.class);

    private IUserService userService;
    
    @Autowired
    private IJwtService jwtService;
    
    @Autowired
	private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    public AdvertiserController(IUserService userService) {
        Assert.notNull(userService, "userService 개체가 반드시 필요!");
        this.userService = userService;
    }

    //이메일 중복 체크 
  	@ApiOperation(value = "이메일 중복 체크", notes = "fail : 중복되는 이메일 있음 | success : 중복되는 이메일 없음")
  	@GetMapping("user/dup/email/{email}")
  	public ResponseEntity<HashMap<String, Object>> signupEmailCheck(@PathVariable("email") String email) throws Exception {
  		HashMap<String, Object> map = new HashMap<String, Object>();
  		
		if(userService.isDupEmail(email)) {//이미 존재하는 계정
			throw new BadRequestException("이미 가입한 계정");
		}else {
			map.put("result", "success");
		}
  	
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
  	}
  	
  	
    
    //회원가입
  	@ApiOperation(value = "회원가입", notes = "회원가입 후 'jwt-token'으로 access token 넘겨줌")
  	@PostMapping(value = "user/join")
  	public ResponseEntity<HashMap<String, Object>> signupUser2(@RequestBody User user, HttpServletResponse response)throws Exception {
      	HashMap<String, Object> map = new HashMap<String, Object>();
      	
//      	String namePt = "^[a-zA-Z0-9가-힣]{2,12}$";
      	String pwPt = "^[0-9a-zA-Z~`!@#$%\\\\^&*()-]{8,12}$";//특수,대소문자,숫자 포함 8자리 이상
      	String emailPt = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$";
      	
      	map.put("result", "fail");
      	
      	if(user.getPassword() == null || user.getPassword().equals("")) {
      		map.put("cause", "비밀번호 입력 필수");
      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      	}
//      	if(!user.getPassword().matches(pwPt)) {
//      		map.put("cause", "비밀번호 형식 오류");
//      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
//      	}
      	
      	
      	if(user.getEmail() == null || user.getEmail().equals("")) {
      		map.put("cause", "이메일 입력 필수");
      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      	}
//      	if(!user.getEmail().matches(emailPt)) {
//      		map.put("cause", "이메일 형식 오류");
//      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
//      	}
      	if(userService.isDupEmail(user.getEmail())) {
      		map.put("cause", "이메일 중복");
      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      	}
      	
      	response.setHeader("Access-Control-Allow-Headers", "token");//token
      	
      	User me = userService.add(user);
  		
      	if(me.getId() > 0) {
      		String token = jwtService.create(Long.toString(me.getId()));
      		map.put("result", "success");
      		map.put("data", me);
      		response.addHeader("token", token);
      		
      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      	}else {
      		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      	}
  	}
      
  	 //로그인
     @ApiOperation(value = "로그인", notes = "로그인 후 'jwt-token'으로 access token 넘겨줌")
     @PostMapping("user/login")
     public ResponseEntity<HashMap<String, Object>> signinUser(@RequestBody Login login
     								, HttpServletResponse response) throws Exception {
	      HashMap<String, Object> map = new HashMap<String, Object>();
	      HttpStatus status = null;
	      	
	      response.setHeader("Access-Control-Allow-Headers", "token");//token
//	      	System.out.println(login.getEmail()+", "+login.getPassword());
		  User user = userService.getUserInfo(login.getEmail());
	  	  if (user == null) {
	  		  throw new NotFoundException("회원 정보 찾을 수 없음");
		  } else {
			  if (!SHA256.testSHA256(login.getPassword()).equals(user.getPassword()))
				  throw new NotFoundException("비밀번호 불일치");
			  user.setPassword("");
			  String token = jwtService.create(Long.toString(user.getId()));

			  map.put("result", "success");
			  map.put("data", user);
			  response.addHeader("token", token);
		  }
	  	  
	  	  status = HttpStatus.ACCEPTED;
	  	  return new ResponseEntity<HashMap<String, Object>>(map, status);
     }
      
     
      //로그아웃
      @ApiOperation(value = "로그아웃", notes = "Authorization header => 'Bearer [token]'")///token
      @GetMapping("/token/user/logout")
	     	public ResponseEntity<HashMap<String, Object>> signoutUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String result = "success";
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	      	
			//access token을 blacklist로
			redisTemplate.opsForValue().set(token, true);
			redisTemplate.expire(token, 10, TimeUnit.DAYS);//10일 후 보관 종료
	
			
			
	  		map.put("result", result);
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
     	}
      
      //회원탈퇴
      @ApiOperation(value = "회원탈퇴", notes = "Authorization header => 'Bearer [token]'")///token
      @DeleteMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> deleteUser(HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String result = "success";
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		String uid = (String)claims.get("uid");
	  		userService.delete(uid);
	  		
	  		map.put("result", result);
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
      }
      
      //회원정보 조회
      @ApiOperation(value = "내 정보 가져오기", notes = "Authorization header => 'Bearer [token]'")///token
      @GetMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> getUserInfo(HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	
	      	
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	map.put("result", "success");
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		String uid = (String)claims.get("uid");
	  		
  			User user = userService.getMyInfo(Long.parseLong(uid));
  			map.put("data", user);
	  			
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
      }
     
      
      //회원정보 수정
      @ApiOperation(value = "회원정보 수정하기", notes = "Authorization header => 'Bearer [token]'")///token
      @PutMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> reviseUser(@ModelAttribute("user") User user, HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		user.setId(Long.parseLong((String)claims.get("uid")));
	  		
	  		userService.update(user);
	  		map.put("result", "success");
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
      }

      
      //비밀번호 확인
      @ApiOperation(value = "비밀번호 확인", notes = "- Authorization header => 'Bearer [token]'\n"
      											+ "- {'passowrd': '~~'} 형식으로 requestbody 보내주세요")///token
      @PostMapping("/token/user/password")
      public ResponseEntity<HashMap<String, Object>> checkPassword(@RequestBody Map<String, Object> param, HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String password = (String)param.get("password");
	      	String result = "success";
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	  		Map<String, Object> claims = jwtService.get(token);
	  		
	  		
  			if(!userService.checkPassword((String)claims.get("uid"), SHA256.testSHA256(password))) {
  				result = "fail";
  				map.put("cause", "비밀번호 불일치");
  			}
	  		
	  		map.put("result", result);
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
      }
      
      //비밀번호 찾기
      @ApiOperation(value = "비밀번호 찾기")
      @GetMapping("/user/password/{email}")
      public ResponseEntity<HashMap<String, Object>> sendEmailForPw(@PathVariable("email") String email, HttpServletRequest request) throws Exception {
	  		HashMap<String, Object> map = new HashMap<String, Object>();
	  		
	  		if(!userService.isDupEmail(email)) {
	  			throw new BadRequestException("가입하지 않은 회원");
	  		}
	  		
	  		String tmpPw = new TempKey().getKey(6, false);  // 임시비밀번호
	      	HttpStatus status = HttpStatus.ACCEPTED;
	      	
	  		userService.sendTmpPasswordEmail(tmpPw, email);
	  				
	        map.put("result", "success");
	  		return new ResponseEntity<HashMap<String, Object>>(map, status);
     }
      

}

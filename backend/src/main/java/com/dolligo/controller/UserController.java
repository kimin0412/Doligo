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
import com.dolligo.dto.Preference;
import com.dolligo.dto.TempKey;
import com.dolligo.dto.User;
import com.dolligo.exception.ApplicationException;
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
public class UserController {
    public static final Logger logger = LoggerFactory.getLogger(UserController.class);

    private IUserService userService;
    
    @Autowired
    private IJwtService jwtService;
    
    @Autowired
	private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    public UserController(IUserService userService) {
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
		}
		
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
  	}
  	
    
    //회원가입(광고 선호도 정보 같이 조회)
  	@ApiOperation(value = "회원가입", notes = "prefercode 리스트에 상권 대분류 코드 리스트(ex. ['D', 'Q', ...])를 넘겨주세용 \n회원가입 후 'token'으로 access token 넘겨줌")
  	@PostMapping(value = "user/signup")
  	public ResponseEntity<HashMap<String, Object>> signupUser(@RequestBody User user, HttpServletResponse response)throws Exception {
      	HashMap<String, Object> map = new HashMap<String, Object>();
      	
      	String pwPt = "^[0-9a-zA-Z~`!@#$%\\\\^&*()-]{8,12}$";//특수,대소문자,숫자 포함 8자리 이상
      	String emailPt = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$";
      	
      	if(user.getPassword() == null || user.getPassword().equals("")) {
      		throw new ApplicationException("비밀번호 입력 필수");
      	}
//      	if(!user.getPassword().matches(pwPt)) {
//      		throw new ApplicationException("비밀번호 형식 오류");
//      	}
      	
      	if(user.getEmail() == null || user.getEmail().equals("")) {
      		throw new ApplicationException("이메일 입력 필수");
      	}
//      	if(!user.getEmail().matches(emailPt)) {
//      		throw new ApplicationException("이메일 형식 오류");
//      	}
      	if(userService.isDupEmail(user.getEmail())) {
      		throw new ApplicationException("이메일 중복");
      	}
      	
      	response.setHeader("Access-Control-Allow-Headers", "token");//token
      	
      	User me = userService.add(user);
  		me.setPassword("");
  		String token = jwtService.create(Integer.toString(me.getId()));
  		map.put("data", me);
  		response.addHeader("token", token);
  		
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
  	}
      
  	 //로그인(광고 선호도 정보 같이 조회)
     @ApiOperation(value = "로그인", notes = "로그인 후 'token'으로 access token 넘겨줌")
     @PostMapping("user/signin")
     public ResponseEntity<HashMap<String, Object>> signinUser(@RequestBody Login login
     								, HttpServletResponse response) throws Exception {
	      HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      response.setHeader("Access-Control-Allow-Headers", "token");//token

	      User user = userService.getUserInfo(login.getEmail());
	  	  if (user == null) {
	  		  throw new NotFoundException("회원 정보 찾을 수 없음");
		  } else {
			  if (!SHA256.testSHA256(login.getPassword()).equals(user.getPassword())) {
				  throw new BadRequestException("비밀번호 불일치");
			  }
			  
			  user.setPassword("");
			  String token = jwtService.create(Integer.toString(user.getId()));

			  map.put("data", user);
			  response.addHeader("token", token);
		  }
	  	  
	  	  return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
     }
      
     
      //로그아웃
      @ApiOperation(value = "로그아웃", notes = "Authorization header => 'Bearer [token]'")///token
      @GetMapping("/token/user/logout")
     	public ResponseEntity<HashMap<String, Object>> signoutUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
      	HashMap<String, Object> map = new HashMap<String, Object>();
      	
      	String token = request.getHeader("Authorization").split(" ")[1];
      	
		//access token을 blacklist로
		redisTemplate.opsForValue().set(token, true);
		redisTemplate.expire(token, 100, TimeUnit.DAYS);//100일 후 보관 종료
		
  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
 	}
      
      //회원탈퇴
      @ApiOperation(value = "회원탈퇴", notes = "Authorization header => 'Bearer [token]'")///token
      @DeleteMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> deleteUser(HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		String uid = (String)claims.get("uid");
	  		userService.delete(uid);
	  		
	  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.OK);
      }
      
      //회원정보 조회(광고 선호도 정보 같이 조회)
      @ApiOperation(value = "내 정보 가져오기", notes = "Authorization header => 'Bearer [token]'")///token
      @GetMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> getUserInfo(HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		String uid = (String)claims.get("uid");
	  		
  			User user = userService.getMyInfo(Integer.parseInt(uid));
  			user.setPassword("");
  			map.put("data", user);
	  			
	  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
      }
     
      
      //회원정보 수정(광고 선호도 정보 같이 수정)
      @ApiOperation(value = "회원정보 수정하기", notes = "preference 리스트에 변경된 광고 선호도 리스트 넘겨주세용.\n Authorization header => 'Bearer [token]'")///token
      @PutMapping("/token/user")
      public ResponseEntity<HashMap<String, Object>> reviseUser(@RequestBody User user, HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	
	  		Map<String, Object> claims = jwtService.get(token);
	  		user.setId(Integer.parseInt((String)claims.get("uid")));
	  		
	  		map.put("data", userService.update(user));
	  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
      }

      //현금화 하기
      @ApiOperation(value = "현금화 하기")// token
      @PostMapping("/token/user/cash/{cash_amount}")
      public ResponseEntity<HashMap<String, Object>> makeCash(@PathVariable("cash_amount") int amount, HttpServletRequest request) throws Exception {
    	  HashMap<String, Object> map = new HashMap<String, Object>();
    	  
    	  String token = request.getHeader("Authorization").split(" ")[1];
    	  
    	  Map<String, Object> claims = jwtService.get(token);
    	  userService.makeCash((String)claims.get("uid"), amount);
    	  
    	  return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
      }

      
      //비밀번호 확인(마이페이지 들어갈 때)
      @ApiOperation(value = "비밀번호 확인", notes = "- Authorization header => 'Bearer [token]'\n"
      											+ "- {'passowrd': '~~'} 형식으로 requestbody 보내주세요")///token
      @PostMapping("/token/user/password")
      public ResponseEntity<HashMap<String, Object>> checkPassword(@RequestBody Map<String, Object> param, HttpServletRequest request) throws Exception {
	      	HashMap<String, Object> map = new HashMap<String, Object>();
	      	
	      	String password = (String)param.get("password");
	      	
	      	String token = request.getHeader("Authorization").split(" ")[1];
	  		Map<String, Object> claims = jwtService.get(token);
	  		
	  		
  			if(!userService.checkPassword((String)claims.get("uid"), SHA256.testSHA256(password))) {
  				throw new ApplicationException("비밀번호 불일치");
  			}
	  		
	  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
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
	      	
	  		userService.sendTmpPasswordEmail(tmpPw, email);
	  				
	  		return new ResponseEntity<HashMap<String, Object>>(map, HttpStatus.ACCEPTED);
     }
      

}

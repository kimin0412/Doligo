package com.dolligo.service.impl;

import java.util.Date;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.dolligo.controller.UserController;
import com.dolligo.service.IJwtService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class JwtService implements IJwtService{

	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Value("${jwt.salt}")
	private String salt;
	
	@Value("${jwt.expmin}")
	private Long expireMin;
	
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;
	
	@Override
	public String create(String uid) {
//		Log.trace("time: {}", expireMin);
		final JwtBuilder builder = Jwts.builder();
		//JWT Token = Header + Payload + Signature
		//Header 설정
		builder.setHeaderParam("typ", "JWT");//토큰 타입으로 고정 값
		
		//Payload 설정 - claim 정보 포함
		builder.setSubject("Login Token")
				.setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 * expireMin))
				.claim("uid", uid);//유저 고유 id
		
		//signature - secret key를 이용한 암호화
		builder.signWith(SignatureAlgorithm.HS256, salt.getBytes());
		
		//직렬화
		final String jwt = builder.compact();
		
		return jwt;
	}

	@Override
	public boolean checkValid(String jwt) {
		Jws<Claims> claims = Jwts.parser().setSigningKey(salt.getBytes()).parseClaimsJws(jwt);
		if(null != redisTemplate.opsForValue().get(jwt)) {
			logger.info("this token is logout!!");
			return false;//logout 상태
		}
		
		return !claims.getBody().getExpiration().before(new Date());//만료 기간 체크
	}

	@Override
	public Map<String, Object> get(String jwt) {
		Jws<Claims> claims = null;//사용자 고유 id 정보 꺼내옴
		try {
			claims = Jwts.parser().setSigningKey(salt.getBytes()).parseClaimsJws(jwt);
		} catch(final Exception e) {
			throw new RuntimeException();
		}
		return claims.getBody();
	}
	
}

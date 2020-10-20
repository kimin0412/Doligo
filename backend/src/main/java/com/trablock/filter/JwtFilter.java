package com.trablock.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;

import com.google.common.net.HttpHeaders;
import com.trablock.application.impl.JwtService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@WebFilter(urlPatterns = "/api/token/*")
public class JwtFilter implements Filter{
	Logger logger = LoggerFactory.getLogger("io.ojw.mall.interceptor.JwtInterceptor");
	private static final String TOKEN = HttpHeaders.AUTHORIZATION;
	
	@Autowired
	private JwtService jwtService;
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;

		//option 요청은 바로 통과
		if(!req.getMethod().equals("OPTIONS")) {
			String token = req.getHeader(TOKEN);
	    	if(token != null && token.length() > 0 && token.split(" ").length == 2) {
				token = token.split(" ")[1];
				request.setAttribute("msg", "토큰 유효하지 않음");
				try {
					if(!jwtService.checkValid(token)) {//토큰 유효성 체크
						request.getRequestDispatcher("/error/jwtfilter").forward(request, response);
//						throw new SecurityException("토큰 유효하지 않음");
					}
					chain.doFilter(request, response);//정상 토큰일 경우
				}catch(Exception e) {//토큰 파싱하다 문제 생긴경우
					request.getRequestDispatcher("/error/jwtfilter").forward(request, response);
//					throw new SecurityException("토큰 유효하지 않음");
				}
			}else {
				request.setAttribute("msg", "토큰 존재하지 않음");
				request.getRequestDispatcher("/error/jwtfilter").forward(request, response);
//				throw new SecurityException("토큰 존재하지 않음");
			}
		}
		
	}

}

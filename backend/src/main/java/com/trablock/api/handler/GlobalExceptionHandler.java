package com.trablock.api.handler;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.trablock.domain.exception.ApplicationException;
import com.trablock.domain.exception.BadRequestException;
import com.trablock.domain.exception.EmptyListException;
import com.trablock.domain.exception.NotFoundException;

import net.gpedro.integrations.slack.SlackApi;
import net.gpedro.integrations.slack.SlackMessage;

@ControllerAdvice
@RestController
public class GlobalExceptionHandler{

    @ResponseStatus(HttpStatus.NOT_FOUND)//404
    @ExceptionHandler(value = NotFoundException.class)
    public HashMap<String, Object> handleNotFoundException(Exception e) {
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("cause", e.getMessage());
		
		return map;
    }
    
    //token 존재여부, 유효성 체크 exception 처리(인증)
    @ResponseStatus(value = HttpStatus.UNAUTHORIZED)//401
    @ExceptionHandler(value = SecurityException.class)
    public HashMap<String, Object> unAuthorizedExceptionHandler(Exception e){
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("cause", e.getMessage());
    	
    	return map;
    }
    
    @ResponseStatus(HttpStatus.BAD_REQUEST)//400
    @ExceptionHandler(value = ApplicationException.class)
    public HashMap<String, Object> handleApplicationException(Exception e) {
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("cause", e.getMessage());
		
		return map;
    }
    
    @ResponseStatus(HttpStatus.BAD_REQUEST)//400
    @ExceptionHandler(value = BadRequestException.class)
    public HashMap<String, Object> badRequestHandleException(Exception e){
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("cause", e.getMessage());
    	
    	return map;
    }

    @ResponseStatus(HttpStatus.NO_CONTENT)//204
    @ExceptionHandler(value = EmptyListException.class)
    public HashMap<String, Object> handleEmptyListException(Exception e) {
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
		
		return map;
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)//500
    @ExceptionHandler(value = Exception.class)
    public HashMap<String, Object> defaultHandleException(HttpServletRequest req, Exception e){
    	e.printStackTrace();
    	HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("cause", e.getMessage());
		
//		StringBuilder msg = new StringBuilder();
//		msg.append(":bangbang:`Backend exception log`\n");
//		msg.append("**ERROR**\t").append(e.toString()).append("\n");
//		msg.append("**URL**\t\t").append(req.getRequestURL()).append("\n");
//  
//		SlackApi api =new SlackApi("https://meeting.ssafy.com/hooks/7rifsd8zajfj7xh5ewop5bwjee");    //웹훅URL
//        api.call(new SlackMessage("jiyooon","spring",msg.toString()));
		
		return map;
    }
    
    
    
    
}

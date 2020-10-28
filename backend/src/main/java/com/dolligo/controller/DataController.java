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

import com.dolligo.data.service.IDataInsertService;
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
@RequestMapping("/api/data")
public class DataController {
    public static final Logger logger = LoggerFactory.getLogger(DataController.class);

    @Autowired
    private IDataInsertService service;
    

    
  	@ApiOperation(value = "insert markettype")
  	@PostMapping(value = "markettype")
  	public void insertMarketType()throws Exception {
      service.insertMarket();
  	}
  	@ApiOperation(value = "insert user")
  	@PostMapping(value = "user")
  	public void insertUser()throws Exception {
  		service.insertUser();
  	}
  	@ApiOperation(value = "insert advertiser")
  	@PostMapping(value = "advertiser")
  	public void insertAdvertiser()throws Exception {
  		service.insertAdvertiser();
  	}
      
  
      

}

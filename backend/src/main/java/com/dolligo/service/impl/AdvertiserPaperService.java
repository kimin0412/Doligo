package com.dolligo.service.impl;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.dolligo.dto.User;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserPaperRepository;
import com.dolligo.repository.IUserRepository;
import com.dolligo.service.IAdvertiserPaperService;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

@Service
public class AdvertiserPaperService implements IAdvertiserPaperService {
	@Autowired
	private IAdvertiserPaperRepository advertiserPaperRepository;
	
    

}

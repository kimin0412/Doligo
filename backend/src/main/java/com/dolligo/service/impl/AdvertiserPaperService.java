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
import com.dolligo.repository.IUserRepository;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

@Service
public class AdvertiserPaperService implements IUserService {

    private IUserRepository userRepository;
    
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    public AdvertiserPaperService(IUserRepository userRepository) {
        this.userRepository = userRepository;
    }


    //다른 유저 정보 가져옴
    @Override
    public User getUserInfo(long id) throws Exception{
    	User user = this.userRepository.getUserById(id);
    	if(user == null) {
    		throw new NotFoundException("회원 정보 찾지 못함");
    	}
    	
    	return user;
    }

    //로그인한 유저 정보 가져옴 => token
    @Override
    public User getMyInfo(long id) throws Exception{
    	User user = this.userRepository.getUserById(id);
    	if(user == null) {
    		throw new NotFoundException("회원 정보 찾지 못함");
    	}
	    
	    return user;
    }
    
    //이메일로 유저정보 가져옴 => login
    @Override
    public User getUserInfo(String email) throws Exception{
    	User user = this.userRepository.getUserByEmail(email);
    	if(user == null) {
    		throw new NotFoundException("회원 정보 찾지 못함");
    	}
    	
    	
    	return user;
    }

    //회원가입
    @Override
    public User add(User user) throws Exception{
        user.setPassword(SHA256.testSHA256(user.getPassword()));
        this.userRepository.create(user);
        
        return user;
    }

    //회원 수정
    @Override
    public User update(User user) throws Exception{

        User found = this.userRepository.getUserById(user.getId());
        if(found == null)
            throw new ApplicationException("회원 정보를 찾을 수 없습니다.");

        if(user.getId() == 0)
            user.setId(found.getId());
        if(user.getNickname() == null || user.getNickname().equals(""))
            user.setNickname(found.getNickname());
        
        if(user.getPassword() == null || user.getPassword().equals(""))
            user.setPassword(found.getPassword());
        else user.setPassword(SHA256.testSHA256(user.getPassword()));
        
        if(user.getEmail() == null || user.getEmail().equals(""))
        	user.setEmail(found.getEmail());

        int affected = this.userRepository.update(user);
        if(affected == 0)
            throw new ApplicationException("회원수정 처리가 반영되지 않았습니다.");

        return this.userRepository.getUserById(user.getId());
    }

    @Override
    public void delete(String id) throws Exception {
        this.userRepository.delete(id);
    }


    //이메일 중복확인
	@Override
	public boolean isDupEmail(String email) throws Exception{
		return userRepository.isDupEmail(email) > 0 ? true : false;
	}




	@Override
	public boolean checkPassword(String uid, String password) throws Exception{
		return userRepository.checkPassword(uid, password) > 0 ? true : false;
	}


	@Override
	public void sendTmpPasswordEmail(String password, String email) throws Exception{
		String title = "TRABLOCK 임시 비밀번호 발급";
		String content = "\n\n안녕하세요!, 임시 비밀번호로 로그인 후 반드시 수정해주세요!!"
						+ "\n\n새 비밀번호 : " + password; // 내용
            
		userRepository.updatePasswordByEmail(email, SHA256.testSHA256(password));
		
		try {
			MimeMessage message = mailSender.createMimeMessage();
	        MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
	        messageHelper.setTo(email); // 받는사람 이메일
	        messageHelper.setSubject(title); // 메일제목
	        messageHelper.setText(content); // 메일 내용
	        
	        mailSender.send(message);
		}catch(MessagingException e) {
			e.printStackTrace();
			throw new ApplicationException(e.getMessage());
		}
	}



}

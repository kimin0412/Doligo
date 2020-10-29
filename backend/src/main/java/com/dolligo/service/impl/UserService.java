package com.dolligo.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.dolligo.dao.MarkettypeDao;
import com.dolligo.dao.PreferenceDao;
import com.dolligo.dto.Preference;
import com.dolligo.dto.User;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IUserRepository;
import com.dolligo.service.IUserService;
import com.dolligo.util.SHA256;

@Service
public class UserService implements IUserService {

    private IUserRepository userRepository;
    
    @Autowired
    private PreferenceDao preferenceDao;

    @Autowired
    private MarkettypeDao markettypeDao;
    
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    public UserService(IUserRepository userRepository) {
        this.userRepository = userRepository;
    }


    //로그인한 유저 정보 가져옴 => token
    @Override
    public User getMyInfo(int id) throws Exception{
    	Optional<User> user = this.userRepository.findById(id);

    	if(!user.isPresent()) {
    		throw new NotFoundException("회원 정보 찾지 못함");
    	}
    	User me = user.get(); 
	    
	    return me;
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
        this.userRepository.save(user);

        List<String> largeList = user.getPrefercode();
        List<Preference> plist = new ArrayList<>();
        for(String l : largeList) {
        	List<Integer> mid = markettypeDao.findByLargecode(l);
        	for(int m : mid) {//유저 광고 선호도 정보 저장
        		Preference p = new Preference(user.getId(), m, true);
        		plist.add(p);
        		preferenceDao.save(p);
        	}
        }
        
        user.setPreferences(plist);
        
        return user;
    }

    //회원 수정
    @Override
    public User update(User user) throws Exception{
        String password = this.userRepository.selectPassword(user.getId());
        
        if(password == null || password.equals("")) {
        	throw new ApplicationException("회원 정보를 찾을 수 없습니다.");
        }

        //비번 변경인 경우
        if(user.getPassword() == null || user.getPassword().equals(""))
            user.setPassword(password);
        else user.setPassword(SHA256.testSHA256(user.getPassword()));
        

        this.userRepository.save(user);
        List<Preference> plist = user.getPreferences();
        
        for(Preference p : plist) {
        	preferenceDao.save(p);
        }

        user.setPassword("");
        return user;
    }

    @Override
    public void delete(String id) throws Exception {
        this.userRepository.deleteById(Integer.parseInt(id));
    }


    //이메일 중복확인
	@Override
	public boolean isDupEmail(String email) throws Exception{
		return userRepository.isDupEmail(email) > 0 ? true : false;
	}


	//본인확인
	@Override
	public boolean checkPassword(String uid, String password) throws Exception{
		return userRepository.checkPassword(uid, password) > 0 ? true : false;
	}


	@Override
	public void sendTmpPasswordEmail(String password, String email) throws Exception{
		String title = "Dolligo 임시 비밀번호 발급";
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

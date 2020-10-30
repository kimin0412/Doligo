package com.dolligo.service.impl;

import java.util.Optional;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Advertiser;
import com.dolligo.exception.ApplicationException;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IAdvertiserRepository;
import com.dolligo.service.IAdvertiserService;
import com.dolligo.util.SHA256;

@Service
public class AdvertiserService implements IAdvertiserService {

	private IAdvertiserRepository advertiserRepository;

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	public AdvertiserService(IAdvertiserRepository advertiserRepository) {
		this.advertiserRepository = advertiserRepository;
	}

	// 로그인한 유저 정보 가져옴 => token
	@Override
	public Advertiser getMyInfo(int id) throws Exception {
		Optional<Advertiser> advertiser = this.advertiserRepository.findById(id);

		if (!advertiser.isPresent()) {
			throw new NotFoundException("회원 정보 찾지 못함");
		}
		Advertiser me = advertiser.get();

		return me;
	}

	// 이메일로 유저정보 가져옴 => login
	@Override
	public Advertiser getAdvertiserInfo(String email) throws Exception {
		Advertiser advertiser = this.advertiserRepository.getAdvertiserByEmail(email);
		if (advertiser == null) {
			throw new NotFoundException("회원 정보 찾지 못함");
		}

		return advertiser;
	}

	@Override
	public Advertiser add(Advertiser advertiser) throws Exception {
		advertiser.setPassword(SHA256.testSHA256(advertiser.getPassword()));
		this.advertiserRepository.save(advertiser);

		return advertiser;
	}

	@Override
	public Advertiser update(Advertiser advertiser) throws Exception {
		String password = this.advertiserRepository.selectPassword(advertiser.getId());

		if (password == null || password.equals("")) {
			throw new ApplicationException("회원 정보를 찾을 수 없습니다.");
		}

		// 비번 변경인 경우
		if (advertiser.getPassword() == null || advertiser.getPassword().equals(""))
			advertiser.setPassword(password);
		else
			advertiser.setPassword(SHA256.testSHA256(advertiser.getPassword()));

		this.advertiserRepository.save(advertiser);

		advertiser.setPassword("");
		return advertiser;
		
		
		
	}

	@Override
	public void delete(String id) throws Exception {
		this.advertiserRepository.deleteById(Integer.parseInt(id));
	}

	@Override
	public boolean isDupEmail(String email) throws Exception {
		System.out.println(email);
		System.out.println(advertiserRepository.isDupEmail(email));
		return advertiserRepository.isDupEmail(email) > 0 ? true : false;
	}

	@Override
	public boolean checkPassword(String uid, String password) throws Exception {
		return advertiserRepository.checkPassword(uid, password) > 0 ? true : false;
	}

	@Override
	public void sendTmpPasswordEmail(String password, String email) throws Exception {
		String title = "Dolligo 임시 비밀번호 발급";
		String content = "\n\n안녕하세요!, 임시 비밀번호로 로그인 후 반드시 수정해주세요!!"
						+ "\n\n새 비밀번호 : " + password; // 내용
            
		advertiserRepository.updatePasswordByEmail(email, SHA256.testSHA256(password));
		
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

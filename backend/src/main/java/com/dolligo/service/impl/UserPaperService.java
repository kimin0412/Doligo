package com.dolligo.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Paper;
import com.dolligo.exception.NotFoundException;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.service.IUserPaperService;

@Service
public class UserPaperService implements IUserPaperService {

	private IPaperRepository paperRepo;
	
	@Autowired
    public UserPaperService(IPaperRepository paperRepo) {
        this.paperRepo = paperRepo;
    }
	
	@Override
	public List<Paper> getPaperList() throws Exception {
		List<Paper> papers = this.paperRepo.findAll();
		if(papers.isEmpty()) {
			throw new NotFoundException("근처에 등록된 전단지가 없습니다.");
		}
		
		return papers;
	}


}

package com.dolligo.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.Paper;
import com.dolligo.dto.User;

public interface IUserPaperService {
	@Transactional
	List<Paper> getPaperList() throws Exception;
}

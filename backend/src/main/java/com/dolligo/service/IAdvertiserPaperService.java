package com.dolligo.service;

import java.util.List;

import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.State;
import com.dolligo.exception.BadRequestException;

public interface IAdvertiserPaperService {
	Paperanalysis getRecentAnalysis(int pid);

	List<Paperanalysis> getAllAnalysis(String aid);

	Paper getPaperDetail(String aid, int pid);

	List<Paper> getAllPaper(String aid);

	void insertPaper(Paper paper);

	void authQrcode(String aid, State state) throws BadRequestException;
}

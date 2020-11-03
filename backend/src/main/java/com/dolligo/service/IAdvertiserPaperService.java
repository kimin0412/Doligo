package com.dolligo.service;

import java.util.List;

import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;

public interface IAdvertiserPaperService {
	Paperanalysis getRecentAnalysis(int pid);

	List<Paperanalysis> getAllAnalysis(String aid);

	Paper getPaperDetail(String aid, int pid);

	List<Paper> getAllPaper(String aid);

	void insertPaper(Paper paper);
}

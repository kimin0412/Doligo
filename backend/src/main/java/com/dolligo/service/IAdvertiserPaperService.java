package com.dolligo.service;

import com.dolligo.dto.Paperanalysis;

public interface IAdvertiserPaperService {
	Paperanalysis getRecentAnalysis(int pid);
}

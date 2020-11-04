package com.dolligo.repository;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.transaction.annotation.Transactional;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.Markettype;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.Preference;
import com.dolligo.dto.User;

@Mapper
public interface IDataInsertRepository {
	public void insertMarket(Markettype marketType);
	public void insertUser(User user);
	public void insertPreference(Preference preference);
	public void insertAdvertiser(Advertiser advertiser);
	public List<Advertiser> getAds(int mtid);
	@Transactional
	public void insertPaper(Paper paper);
	public void insertPaperAnalysis(int pid);
}


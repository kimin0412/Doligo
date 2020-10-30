package com.dolligo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.Markettype;
import com.dolligo.dto.Preference;
import com.dolligo.dto.User;

@Mapper
public interface IDataInsertRepository {
	public void insertMarket(Markettype marketType);
	public void insertUser(User user);
	public void insertPreference(Preference preference);
	public void insertAdvertiser(Advertiser advertiser);
	
}


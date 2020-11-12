package com.dolligo.data.service;

import java.io.IOException;

import com.dolligo.dto.Preference;
import com.dolligo.dto.User;

public interface IDataInsertService {
	public void insertMarket() throws IOException;
	public void insertUser() throws IOException;
	public void insertAdvertiser() throws IOException;
	public void insertPaper() throws IOException;
	public void insertOtherUser() throws Exception;
	public void insertUserAction() throws Exception;
}

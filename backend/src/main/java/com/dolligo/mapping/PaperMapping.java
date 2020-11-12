package com.dolligo.mapping;

import com.dolligo.dto.Advertiser;
import com.fasterxml.jackson.annotation.JsonIgnore;

public interface PaperMapping {
	int getP_id();
	int getP_aid();
	int getP_mtid();
	String getP_image();
	String getP_video();
	int getP_point();
	boolean isP_check();
	String getP_coupon();
	String getCondition1();
	String getCondition2();
	String getStarttime();
	String getEndtime();
	String getLat();
	String getLon();
	int getSheets();
	int getRemainsheets();
	int getCost();
	
//	Advertiser getAdvertiser();
	
	String getAdvertiserPassword();
}

package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//광고주 유저
@Data
public class Advertiser {
    private int id;						//pk
    private int mtid;					//fk : 상권종류 아이디(MarketTypeId)
    private String email;				//이메일
    private String password;			//비밀번호
    private String marketname;			//가게이름
    private String marketnumber;		//가게번호
    private String marketaddress;		//가게주소
    private String marketurl;			//가게 url
    private String lat;					//위도
    private String lon;					//경도
    private int point;					//포인트
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getMtid() {
		return mtid;
	}
	public void setMtid(int mtid) {
		this.mtid = mtid;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getMarketname() {
		return marketname;
	}
	public void setMarketname(String marketname) {
		this.marketname = marketname;
	}
	public String getMarketnumber() {
		return marketnumber;
	}
	public void setMarketnumber(String marketnumber) {
		this.marketnumber = marketnumber;
	}
	public String getMarketaddress() {
		return marketaddress;
	}
	public void setMarketaddress(String marketaddress) {
		this.marketaddress = marketaddress;
	}
	public String getMarketurl() {
		return marketurl;
	}
	public void setMarketurl(String marketurl) {
		this.marketurl = marketurl;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLon() {
		return lon;
	}
	public void setLon(String lon) {
		this.lon = lon;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	@Override
	public String toString() {
		return "Advertiser [id=" + id + ", mtid=" + mtid + ", email=" + email + ", password=" + password
				+ ", marketname=" + marketname + ", marketnumber=" + marketnumber + ", marketaddress=" + marketaddress
				+ ", marketurl=" + marketurl + ", lat=" + lat + ", lon=" + lon + ", point=" + point + "]";
	}
    
    
    
    
}

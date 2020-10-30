package com.dolligo.dto;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators.IntSequenceGenerator;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//광고주 유저
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
@JsonIdentityInfo(generator = IntSequenceGenerator.class, property = "id") // 무한루프방지
public class Advertiser {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;						//pk
    private int mtid;					//fk : 상권종류 아이디(MarketTypeId)
    private String email;				//이메일
    private String password;			//비밀번호
    private String marketname;			//가게이름
    private String marketbranch;		//가게지점
    private String marketnumber;		//가게번호
    private String marketaddress;		//가게주소
    private String marketurl;			//가게 url
    private String lat;					//위도
    private String lon;					//경도
    private int point;					//포인트
    
    @OneToMany(mappedBy = "advertiser")
    private List<Paper> papers;
    
    @Transient
    private String mediumcode;
    
	public String getMediumcode() {
		return mediumcode;
	}
	public void setMediumcode(String mediumcode) {
		this.mediumcode = mediumcode;
	}
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
	public String getMarketbranch() {
		return marketbranch;
	}
	public void setMarketbranch(String marketbranch) {
		this.marketbranch = marketbranch;
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
	
	public List<Paper> getPapers() {
		return papers;
	}
	public void setPapers(List<Paper> papers) {
		this.papers = papers;
	}
	@Override
	public String toString() {
		return "Advertiser [id=" + id + ", mtid=" + mtid + ", email=" + email + ", password=" + password
				+ ", marketname=" + marketname + ", marketbranch=" + marketbranch + ", marketnumber=" + marketnumber
				+ ", marketaddress=" + marketaddress + ", marketurl=" + marketurl + ", lat=" + lat + ", lon=" + lon
				+ ", point=" + point + ", papers=" + papers + ", mediumcode=" + mediumcode + "]";
	}
	
	
	
}

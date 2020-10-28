package com.dolligo.dto;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//전단지 등록 + 배포
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Distribute {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
	private int id;				//pk
	private int pid;			//fk  전단지 아이디(paperId)
	private int aid;			//fk  광고주 아이디(advertiserId)
	private int mtid;			//fk  상권종류 아이디(marketTypeId)
	private String startdate;	//배포 시작 시간
	private String enddate;		//배포 종료 시간
	private String lat;			//배포 위치 위도
	private String lon;			//배포 위치 경도
	private int sheets;			//초기 종이수
	private int remainsheets;	//배포 후 남은 종이수
	private int cost;			//결제 금액
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public int getAid() {
		return aid;
	}
	public void setAid(int aid) {
		this.aid = aid;
	}
	public int getMtid() {
		return mtid;
	}
	public void setMtid(int mtid) {
		this.mtid = mtid;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
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
	public int getSheets() {
		return sheets;
	}
	public void setSheets(int sheets) {
		this.sheets = sheets;
	}
	public int getRemainsheets() {
		return remainsheets;
	}
	public void setRemainsheets(int remainsheets) {
		this.remainsheets = remainsheets;
	}
	public int getCost() {
		return cost;
	}
	public void setCost(int cost) {
		this.cost = cost;
	}
	@Override
	public String toString() {
		return "Distribute [id=" + id + ", pid=" + pid + ", aid=" + aid + ", mtid=" + mtid + ", startdate=" + startdate
				+ ", enddate=" + enddate + ", lat=" + lat + ", lon=" + lon + ", sheets=" + sheets + ", remainsheets="
				+ remainsheets + ", cost=" + cost + "]";
	}
	
	
	
}

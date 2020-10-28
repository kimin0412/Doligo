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
	private int d_id;				//pk
	private int d_pid;			//fk  전단지 아이디(paperId)
	private int d_aid;			//fk  광고주 아이디(advertiserId)
	private int d_mtid;			//fk  상권종류 아이디(marketTypeId)
	private String d_startdate;	//배포 시작 시간
	private String d_enddate;		//배포 종료 시간
	private String d_lat;			//배포 위치 위도
	private String d_lon;			//배포 위치 경도
	private int d_sheets;			//초기 종이수
	private int d_remainsheets;	//배포 후 남은 종이수
	private int d_cost;			//결제 금액
	
	public int getD_id() {
		return d_id;
	}
	public void setD_id(int d_id) {
		this.d_id = d_id;
	}
	public int getD_pid() {
		return d_pid;
	}
	public void setD_pid(int d_pid) {
		this.d_pid = d_pid;
	}
	public int getD_aid() {
		return d_aid;
	}
	public void setD_aid(int d_aid) {
		this.d_aid = d_aid;
	}
	public int getD_mtid() {
		return d_mtid;
	}
	public void setD_mtid(int d_mtid) {
		this.d_mtid = d_mtid;
	}
	public String getD_startdate() {
		return d_startdate;
	}
	public void setD_startdate(String d_startdate) {
		this.d_startdate = d_startdate;
	}
	public String getD_enddate() {
		return d_enddate;
	}
	public void setD_enddate(String d_enddate) {
		this.d_enddate = d_enddate;
	}
	public String getD_lat() {
		return d_lat;
	}
	public void setD_lat(String d_lat) {
		this.d_lat = d_lat;
	}
	public String getD_lon() {
		return d_lon;
	}
	public void setD_lon(String d_lon) {
		this.d_lon = d_lon;
	}
	public int getD_sheets() {
		return d_sheets;
	}
	public void setD_sheets(int d_sheets) {
		this.d_sheets = d_sheets;
	}
	public int getD_remainsheets() {
		return d_remainsheets;
	}
	public void setD_remainsheets(int d_remainsheets) {
		this.d_remainsheets = d_remainsheets;
	}
	public int getD_cost() {
		return d_cost;
	}
	public void setD_cost(int d_cost) {
		this.d_cost = d_cost;
	}
	public Distribute() {
		super();
	}
	public Distribute(int d_id, int d_pid, int d_aid, int d_mtid, String d_startdate, String d_enddate, String d_lat,
			String d_lon, int d_sheets, int d_remainsheets, int d_cost) {
		super();
		this.d_id = d_id;
		this.d_pid = d_pid;
		this.d_aid = d_aid;
		this.d_mtid = d_mtid;
		this.d_startdate = d_startdate;
		this.d_enddate = d_enddate;
		this.d_lat = d_lat;
		this.d_lon = d_lon;
		this.d_sheets = d_sheets;
		this.d_remainsheets = d_remainsheets;
		this.d_cost = d_cost;
	}
	
	
}

package com.dolligo.dto;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.annotations.ColumnDefault;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators.IntSequenceGenerator;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//전단지
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class PaperForPost implements Serializable{
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int p_id;					//pk
    private int p_aid;				//fk  광고주아이디(advertiserId)
    private int p_mtid;				//fk  상권종류 아이디(marketTypeId)
    private String p_image;			//이미지 url
    private String p_video;			//비디오 url
    private int p_point;				//포인트
    private boolean p_check;			//전단지 승인 여부
    private String p_coupon;			//쿠폰 내용
    private String condition1;			//쿠폰 조건1
    private String condition2;			//쿠폰 조건2
    private String starttime;			//배포 시작시간
    private String endtime;				//배포 종료 시간
    private String lat;					//배포할 위치 위도
    private String lon;					//배포할 위치 경도
    @ColumnDefault(value = "0") 
    private int sheets;					//배포할 종이 수
    @ColumnDefault(value = "0") 
    private int remainsheets;			//배포 후 남은 종이 수
    @ColumnDefault(value = "0") 
    private int cost;					//결제 금액
  
	public int getP_id() {
		return p_id;
	}
	public void setP_id(int p_id) {
		this.p_id = p_id;
	}
	public int getP_aid() {
		return p_aid;
	}
	public void setP_aid(int p_aid) {
		this.p_aid = p_aid;
	}
	public int getP_mtid() {
		return p_mtid;
	}
	public void setP_mtid(int p_mtid) {
		this.p_mtid = p_mtid;
	}
	public String getP_image() {
		return p_image;
	}
	public void setP_image(String p_image) {
		this.p_image = p_image;
	}
	public String getP_video() {
		return p_video;
	}
	public void setP_video(String p_video) {
		this.p_video = p_video;
	}
	public int getP_point() {
		return p_point;
	}
	public void setP_point(int p_point) {
		this.p_point = p_point;
	}
	public boolean isP_check() {
		return p_check;
	}
	public void setP_check(boolean p_check) {
		this.p_check = p_check;
	}
	public String getP_coupon() {
		return p_coupon;
	}
	public void setP_coupon(String p_coupon) {
		this.p_coupon = p_coupon;
	}
	public String getCondition1() {
		return condition1;
	}
	public void setCondition1(String condition1) {
		this.condition1 = condition1;
	}
	public String getCondition2() {
		return condition2;
	}
	public void setCondition2(String condition2) {
		this.condition2 = condition2;
	}
	public String getStarttime() {
		return starttime;
	}
	public void setStarttime(String starttime) {
		this.starttime = starttime;
	}
	public String getEndtime() {
		return endtime;
	}
	public void setEndtime(String endtime) {
		this.endtime = endtime;
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
		return "Paper [p_id=" + p_id + ", p_aid=" + p_aid + ", p_mtid=" + p_mtid + ", p_image=" + p_image + ", p_video="
				+ p_video + ", p_point=" + p_point + ", p_check=" + p_check + ", p_coupon=" + p_coupon + ", condition1="
				+ condition1 + ", condition2=" + condition2 + ", starttime=" + starttime + ", endtime=" + endtime
				+ ", lat=" + lat + ", lon=" + lon + ", sheets=" + sheets + ", remainsheets=" + remainsheets + ", cost="
				+ cost + "]";
	}
	
	
	
	
    
}

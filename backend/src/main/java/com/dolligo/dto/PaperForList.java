package com.dolligo.dto;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.annotations.ColumnDefault;

import com.dolligo.mapping.PaperMapping;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators.IntSequenceGenerator;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//전단지목록
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class PaperForList implements Serializable, Comparable<PaperForList>{
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int p_id;					//pk
    private int p_aid;				//fk  광고주아이디(advertiserId)
    private int p_mtid;				//fk  상권종류 아이디(marketTypeId)
    private String p_image;			//이미지 url
    private String p_video;			//비디오 url
    private String lat;					//배포할 위치 위도
    private String lon;					//배포할 위치 경도
    private String marketname;			//가게 이름
    private String marketaddress;		//가게 주소
    private int sheets;					//배포 장 수
    @Transient
    private int prefer;//전단지 선호도 점수
    @Transient
    private double distance;//현재 내 위치로부터 전단지까지의 거리(가게 위치가 중요하니까..사실 중요한 정보는 아닌듯...)
    @Transient
    private boolean first;//처음 받는 전단지 여부
    
    
    @Override
    public int compareTo(PaperForList p) {//선호도 가중치 기준 내림차순 정렬
    	return Integer.compare(p.prefer, this.prefer);
    }
    
    
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
	
	
	public String getMarketname() {
		return marketname;
	}


	public void setMarketname(String marketname) {
		this.marketname = marketname;
	}


	public String getMarketaddress() {
		return marketaddress;
	}


	public void setMarketaddress(String marketaddress) {
		this.marketaddress = marketaddress;
	}
	

	public int getSheets() {
		return sheets;
	}


	public void setSheets(int sheets) {
		this.sheets = sheets;
	}


	public int getPrefer() {
		return prefer;
	}
	public void setPrefer(int prefer) {
		this.prefer = prefer;
	}
	public double getDistance() {
		return distance;
	}
	public void setDistance(double distance) {
		this.distance = distance;
	}
	
	public boolean isFirst() {
		return first;
	}

	public void setFirst(boolean first) {
		this.first = first;
	}


	@Override
	public String toString() {
		return "PaperForList [p_id=" + p_id + ", p_aid=" + p_aid + ", p_mtid=" + p_mtid + ", p_image=" + p_image
				+ ", p_video=" + p_video + ", lat=" + lat + ", lon=" + lon + ", marketname=" + marketname
				+ ", marketaddress=" + marketaddress + ", sheets=" + sheets + ", prefer=" + prefer + ", distance="
				+ distance + ", first=" + first + "]";
	}


	
	
	
    
}

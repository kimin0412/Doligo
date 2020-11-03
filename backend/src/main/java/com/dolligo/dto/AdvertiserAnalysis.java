package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

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

//광고주별 분석
@Entity
@Getter
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class AdvertiserAnalysis {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
	private int id;					//pk
	private int aid;				//fk 광고주 아이디
	private int mtid;				//fk 상권 아이디
	private boolean gender;			//성별
	private int age;				//연령대
	private int state;				//반응상태값
	private LocalDateTime time;			//반응시간
	
	
	public AdvertiserAnalysis() {};
	public AdvertiserAnalysis(int aid, int mtid, boolean gender, int age, int state) {
		super();
		this.aid = aid;
		this.mtid = mtid;
		this.gender = gender;
		this.age = age;
		this.state = state;
		this.time = LocalDateTime.now();
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public boolean isGender() {
		return gender;
	}
	public void setGender(boolean gender) {
		this.gender = gender;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public LocalDateTime getTime() {
		return time;
	}
	public void setTime(LocalDateTime time) {
		this.time = time;
	}
	@Override
	public String toString() {
		return "AdvertiserAnalysis [id=" + id + ", aid=" + aid + ", mtid=" + mtid + ", gender=" + gender + ", age="
				+ age + ", state=" + state + ", time=" + time + "]";
	}
	
	
	
    
    
}

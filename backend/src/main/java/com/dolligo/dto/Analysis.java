package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//분석결과
@Data
public class Analysis {
	private int id;					//pk
	private boolean type;			//상권인지 전단지인지
	private int targetid;			//상권/ 전단지 아이디
	private boolean gender;			//성별  0 : 여자, 1 : 남자
	private int age;				//연령(년도, 뒤에 숫자 두 개)
	private int state;				//차단, 바로삭제, 상세조회, 방문(qr인증) 체크
	private boolean isdiscount;		//이벤트 여부
	private int cnt;				//누적 횟수(쌓인 유저 데이터 개수)
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public boolean isType() {
		return type;
	}
	public void setType(boolean type) {
		this.type = type;
	}
	public int getTargetid() {
		return targetid;
	}
	public void setTargetid(int targetid) {
		this.targetid = targetid;
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
	public boolean isIsdiscount() {
		return isdiscount;
	}
	public void setIsdiscount(boolean isdiscount) {
		this.isdiscount = isdiscount;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	@Override
	public String toString() {
		return "Analysis [id=" + id + ", type=" + type + ", targetid=" + targetid + ", gender=" + gender + ", age="
				+ age + ", state=" + state + ", isdiscount=" + isdiscount + ", cnt=" + cnt + "]";
	}
	
	
    
    
}

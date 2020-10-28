package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//선호도
@Data
public class Preference {
    private int id;				//pk
    private int uid;			//fk  일반유저 아이디(userId)
    private int mid;			//fk  상권종류 아이디(marketTypeId)
    private boolean isprefer;	//선호여부	=> 0 : 비선호, 1 : 선호
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public int getMid() {
		return mid;
	}
	public void setMid(int mid) {
		this.mid = mid;
	}
	public boolean isIsprefer() {
		return isprefer;
	}
	public void setIsprefer(boolean isprefer) {
		this.isprefer = isprefer;
	}
	@Override
	public String toString() {
		return "Preference [id=" + id + ", uid=" + uid + ", mid=" + mid + ", isprefer=" + isprefer + "]";
	}
    
    
    
}

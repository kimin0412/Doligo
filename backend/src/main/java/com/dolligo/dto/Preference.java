package com.dolligo.dto;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//선호도
@Entity
@Getter
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Preference {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;				//pk
    private int uid;			//fk  일반유저 아이디(userId)
    private int mid;			//fk  상권종류 아이디(marketTypeId)
    private boolean isprefer;	//선호여부	=> 0 : 비선호, 1 : 선호
    
    @Transient
    private String mname;	//상권 중분류 이름
    
	public String getMname() {
		return mname;
	}
	public void setMname(String mname) {
		this.mname = mname;
	}
    
    public Preference() {};
	public Preference(int uid, int mid, boolean isprefer) {
		super();
		this.uid = uid;
		this.mid = mid;
		this.isprefer = isprefer;
	}
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

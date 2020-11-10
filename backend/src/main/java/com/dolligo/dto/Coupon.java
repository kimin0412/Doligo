package com.dolligo.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//쿠폰
@Entity
@Getter
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Coupon implements Serializable{
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;					//pk
	private int pid;				//fk 전단지 아이디
	private int uid;				//fk 일반 유저 아이디
	private LocalDateTime created;			//쿠폰 저장 시간(날짜로부터 30일 유효기한)
	private boolean used;			//쿠폰 사용 여부
	
	@ManyToOne(targetEntity = Paper.class)
    @JoinColumn(name = "pid", insertable = false, updatable = false)
    private Paper paper;
	
	public Coupon() {};
	public Coupon(int pid, int uid) {
		super();
		this.created = LocalDateTime.now();
		this.pid = pid;
		this.uid = uid;
	}


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
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public LocalDateTime getCreated() {
		return created;
	}
	public void setCreated(LocalDateTime created) {
		this.created = created;
	}
	public boolean isUsed() {
		return used;
	}
	public void setUsed(boolean used) {
		this.used = used;
	}
	
	public Paper getPaper() {
		return paper;
	}
	public void setPaper(Paper paper) {
		this.paper = paper;
	}
	
	@Override
	public String toString() {
		return "Coupon [id=" + id + ", pid=" + pid + ", uid=" + uid + ", created=" + created + ", used=" + used
				+ ", paper=" + paper + "]";
	}
	
    
}

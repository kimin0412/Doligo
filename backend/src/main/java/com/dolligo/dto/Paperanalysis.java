package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

//전단지별 분석
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Paperanalysis {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
	private int id;					//pk
	private int pid;				//fk 전단지 아이디
	private int distributed;		//배포된 종이 양
	private int visit;				//방문한 사람 수
	private int interest;			//상세조회한 사람 수(포인트받기 버튼 클릭)
	private int disregard;				//바로 삭제한 사람 수
	private int block;				//차단한 사람 수
	
	@OneToOne
	@JoinColumn(name = "pid", insertable = false, updatable = false)
    private Paper paper;
	
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
	public int getDistributed() {
		return distributed;
	}
	public void setDistributed(int distributed) {
		this.distributed = distributed;
	}
	public int getVisit() {
		return visit;
	}
	public void setVisit(int visit) {
		this.visit = visit;
	}
	public int getInterest() {
		return interest;
	}
	public void setInterest(int interest) {
		this.interest = interest;
	}
	public int getDisregard() {
		return disregard;
	}
	public void setDisregard(int disregard) {
		this.disregard = disregard;
	}
	public int getBlock() {
		return block;
	}
	public void setBlock(int block) {
		this.block = block;
	}
	
	public Paper getPaper() {
		return paper;
	}
	public void setPaper(Paper paper) {
		this.paper = paper;
	}
	@Override
	public String toString() {
		return "Paperanalysis [id=" + id + ", pid=" + pid + ", distributed=" + distributed + ", visit=" + visit
				+ ", interest=" + interest + ", disregard=" + disregard + ", block=" + block + ", paper=" + paper + "]";
	}
	
    
}

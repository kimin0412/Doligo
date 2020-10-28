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

//전단지 상태(일반유저의 로그 데이터)
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Paperstate {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int ps_id;					//pk  전단지상태 아이디
    private int ps_uid;				//fk  일반 유저 아이디(userId)
    private int ps_pid;				//fk  전단지 아이디(paperId)
    private int ps_aid;				//fk  광고주 아이디(advertiserId)
    private int ps_mtid;				//fk  상권종류 아이디(marketTypeId)
    private int ps_state;				//전단지 받았을 때 유저 로그 데이터 => 0 : 조회X, 1 : 조회O
    								/*
    								 * state == 0 일때 전단지를 리스트에서 삭제하거나 차단할 경우
    								 * => paperstate 테이블에서 삭제 후 analysis 테이블의 state 값 갱신
    								 */
    private boolean ps_visited;		//가게 방문 여부
    private boolean ps_couponused;		//쿠폰 사용여부
    private boolean ps_isget;			//포인트 회수 여부(상세조회 페이지에서 '포인트받기' 버튼 눌렀는지 여부)
    private int ps_point;				//해당 광고를 통해 얻은 포인트 총 양
	public int getPs_id() {
		return ps_id;
	}
	public void setPs_id(int ps_id) {
		this.ps_id = ps_id;
	}
	public int getPs_uid() {
		return ps_uid;
	}
	public void setPs_uid(int ps_uid) {
		this.ps_uid = ps_uid;
	}
	public int getPs_pid() {
		return ps_pid;
	}
	public void setPs_pid(int ps_pid) {
		this.ps_pid = ps_pid;
	}
	public int getPs_aid() {
		return ps_aid;
	}
	public void setPs_aid(int ps_aid) {
		this.ps_aid = ps_aid;
	}
	public int getPs_mtid() {
		return ps_mtid;
	}
	public void setPs_mtid(int ps_mtid) {
		this.ps_mtid = ps_mtid;
	}
	public int getPs_state() {
		return ps_state;
	}
	public void setPs_state(int ps_state) {
		this.ps_state = ps_state;
	}
	public boolean isPs_visited() {
		return ps_visited;
	}
	public void setPs_visited(boolean ps_visited) {
		this.ps_visited = ps_visited;
	}
	public boolean isPs_couponused() {
		return ps_couponused;
	}
	public void setPs_couponused(boolean ps_couponused) {
		this.ps_couponused = ps_couponused;
	}
	public boolean isPs_isget() {
		return ps_isget;
	}
	public void setPs_isget(boolean ps_isget) {
		this.ps_isget = ps_isget;
	}
	public int getPs_point() {
		return ps_point;
	}
	public void setPs_point(int ps_point) {
		this.ps_point = ps_point;
	}
	
	public Paperstate() {
		super();
	}
	public Paperstate(int ps_id, int ps_uid, int ps_pid, int ps_aid, int ps_mtid, int ps_state, boolean ps_visited,
			boolean ps_couponused, boolean ps_isget, int ps_point) {
		super();
		this.ps_id = ps_id;
		this.ps_uid = ps_uid;
		this.ps_pid = ps_pid;
		this.ps_aid = ps_aid;
		this.ps_mtid = ps_mtid;
		this.ps_state = ps_state;
		this.ps_visited = ps_visited;
		this.ps_couponused = ps_couponused;
		this.ps_isget = ps_isget;
		this.ps_point = ps_point;
	}
    
}

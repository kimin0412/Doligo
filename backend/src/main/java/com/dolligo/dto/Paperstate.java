package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//전단지 상태(일반유저의 로그 데이터)
@Data
public class Paperstate {
    private int id;					//pk  전단지상태 아이디
    private int uid;				//fk  일반 유저 아이디(userId)
    private int pid;				//fk  전단지 아이디(paperId)
    private int aid;				//fk  광고주 아이디(advertiserId)
    private int mtid;				//fk  상권종류 아이디(marketTypeId)
    
    private int state;				//전단지 받았을 때 유저 로그 데이터 => 0 : 조회X, 1 : 조회O
    								/*
    								 * state == 0 일때 전단지를 리스트에서 삭제하거나 차단할 경우
    								 * => paperstate 테이블에서 삭제 후 analysis 테이블의 state 값 갱신
    								 */
    private boolean visited;		//가게 방문 여부
    private boolean couponused;		//쿠폰 사용여부
    private boolean isget;			//포인트 회수 여부(상세조회 페이지에서 '포인트받기' 버튼 눌렀는지 여부)
    
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
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
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
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	public boolean isVisited() {
		return visited;
	}
	public void setVisited(boolean visited) {
		this.visited = visited;
	}
	public boolean isCouponused() {
		return couponused;
	}
	public void setCouponused(boolean couponused) {
		this.couponused = couponused;
	}
	public boolean isIsget() {
		return isget;
	}
	public void setIsget(boolean isget) {
		this.isget = isget;
	}
	@Override
	public String toString() {
		return "Paperstate [id=" + id + ", uid=" + uid + ", pid=" + pid + ", aid=" + aid + ", mtid=" + mtid + ", state="
				+ state + ", visited=" + visited + ", couponused=" + couponused + ", isget=" + isget + "]";
	}
    
	
    
    
}

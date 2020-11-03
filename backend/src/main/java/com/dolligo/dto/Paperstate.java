package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
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
import lombok.Setter;

//전단지 상태(일반유저의 로그 데이터)
@Entity
@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Paperstate {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;					//pk  전단지상태 아이디
    private int uid;				//fk  일반 유저 아이디(userId)
    private int pid;				//fk  전단지 아이디(paperId)
    private int state;				//전단지 받았을 때 유저 로그 데이터 => 1 : 무시, 2 : 상세조회포인트, 3 : qr인증, 4: 차단
    								/*
    								 * state == 0 일때 전단지를 리스트에서 삭제하거나 차단할 경우
    								 * => paperstate 테이블에서 삭제 후 analysis 테이블의 state 값 갱신
    								 */
    private boolean visited;		//가게 방문 여부
    private boolean isget;			//포인트 회수 여부(상세조회 페이지에서 '포인트받기' 버튼 눌렀는지 여부)
    private int point;				//직전 상태 변경으로 얻은 포인트
    private int totalpoint;			//이 전단지로 얻은 포인트 총 양
    
    
    @ManyToOne
    @JoinColumn(name = "pid", insertable = false, updatable = false)
    private Paper paper;//어느 전단지의 paperstate인지
    
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
	public boolean isIsget() {
		return isget;
	}
	public void setIsget(boolean isget) {
		this.isget = isget;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	
	public Paper getPaper() {
		return paper;
	}
	public void setPaper(Paper paper) {
		this.paper = paper;
	}
	
	public int getTotalpoint() {
		return totalpoint;
	}
	public void setTotalpoint(int totalpoint) {
		this.totalpoint = totalpoint;
	}
	@Override
	public String toString() {
		return "Paperstate [id=" + id + ", uid=" + uid + ", pid=" + pid + ", state=" + state + ", visited=" + visited
				+ ", isget=" + isget + ", point=" + point + ", totalpoint=" + totalpoint + ", paper=" + paper + "]";
	}
	
	
    
}

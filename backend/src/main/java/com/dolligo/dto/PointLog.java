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
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

//포인트 로그
@Entity
@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class PointLog {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;					// pk 아이디
	private int uid;				// fk 일반 유저 아이디
	private int sid;				// fk 포인트 출처 종류 아이디(전단지, 기프티콘, 현금화 등)
	private int source;				// 포인트 출처 아이디(paper_id || gifticon_id)
	private int point;				// 얻거나 잃은 포인트
	private int totalPoint;			// 전체 포인트
	private LocalDateTime created;	// 생성 시간
	private String description;		// 포인트 내용
    
    
    @ManyToOne
    @JoinColumn(name = "sid", insertable = false, updatable = false)
    private PointSource pointSource;// 포인트 출처 종류


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


	public int getSid() {
		return sid;
	}


	public void setSid(int sid) {
		this.sid = sid;
	}


	public int getSource() {
		return source;
	}


	public void setSource(int source) {
		this.source = source;
	}


	public int getPoint() {
		return point;
	}


	public void setPoint(int point) {
		this.point = point;
	}


	public int getTotalPoint() {
		return totalPoint;
	}


	public void setTotalPoint(int totalPoint) {
		this.totalPoint = totalPoint;
	}


	public LocalDateTime getCreated() {
		return created;
	}


	public void setCreated(LocalDateTime created) {
		this.created = created;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public PointSource getPointSource() {
		return pointSource;
	}


	public void setPointSource(PointSource pointSource) {
		this.pointSource = pointSource;
	}


	@Override
	public String toString() {
		return "PointLog [id=" + id + ", uid=" + uid + ", sid=" + sid + ", source=" + source + ", point=" + point
				+ ", totalPoint=" + totalPoint + ", created=" + created + ", description=" + description
				+ ", pointSource=" + pointSource + "]";
	}
    
    
	
    
}

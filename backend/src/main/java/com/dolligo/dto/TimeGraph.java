package com.dolligo.dto;

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

@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
//@JsonIdentityInfo(generator = IntSequenceGenerator.class, property = "id") // 무한루프방지
public class TimeGraph {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
	int deleteCnt;
	int pointCnt;
	int visitCnt;
	int blockCnt;
	
	public int getDeleteCnt() {
		return deleteCnt;
	}
	public void setDeleteCnt(int deleteCnt) {
		this.deleteCnt = deleteCnt;
	}
	public int getBlockCnt() {
		return blockCnt;
	}
	public void setBlockCnt(int blockCnt) {
		this.blockCnt = blockCnt;
	}
	public int getPointCnt() {
		return pointCnt;
	}
	public void setPointCnt(int pointCnt) {
		this.pointCnt = pointCnt;
	}
	public int getVisitCnt() {
		return visitCnt;
	}
	public void setVisitCnt(int visitCnt) {
		this.visitCnt = visitCnt;
	}
	@Override
	public String toString() {
		return "TimeGraph [deleteCnt=" + deleteCnt + ", blockCnt=" + blockCnt + ", pointCnt=" + pointCnt + ", visitCnt="
				+ visitCnt + "]";
	}
	
}

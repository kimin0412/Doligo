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

//차단
@Entity
@Getter
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Block {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;					//pk
	private int uid;				//fk 일반 유저 아이디
	private int aid;				//fk 차단할 광고주 아이디
	private int mtid;				//fk 상권 아이디
	
	@ManyToOne
    @JoinColumn(name = "aid", insertable = false, updatable = false)
    private Advertiser advertiser;
	
	public Block() {}
	
	public Block(int uid, int aid, int mtid) {
		super();
		this.uid = uid;
		this.aid = aid;
		this.mtid = mtid;
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
	
	public Advertiser getAdvertiser() {
		this.advertiser.setPassword("");
		return advertiser;
	}

	public void setAdvertiser(Advertiser advertiser) {
		this.advertiser = advertiser;
	}

	@Override
	public String toString() {
		return "Block [id=" + id + ", uid=" + uid + ", aid=" + aid + ", mtid=" + mtid + ", advertiser=" + advertiser
				+ "]";
	}

	
	
	
	
	
	
    
}

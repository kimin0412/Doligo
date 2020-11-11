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

//기프티콘
@Entity
@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class GifticonPurchase {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;						// pk 아이디
	private int gid;					// fk 기프티콘 아이디
	private int uid;					// fk 일반유저 아이디
	private boolean used;				// 기프티콘 사용 여부 => true : 사용함, false : 사용 안함
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getGid() {
		return gid;
	}
	public void setGid(int gid) {
		this.gid = gid;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public boolean isUsed() {
		return used;
	}
	public void setUsed(boolean used) {
		this.used = used;
	}
	@Override
	public String toString() {
		return "GifticonPurchase [id=" + id + ", gid=" + gid + ", uid=" + uid + ", used=" + used + "]";
	}
	
    
}

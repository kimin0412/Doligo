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

//상권종류
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Markettype {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
	private int id;				//pk
	private String largecode;	//대분류코드
	private String largename;	//대분류이름
	private String mediumcode;	//중분류코드
	private String mediumname;	//중분류이름
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getLargecode() {
		return largecode;
	}
	public void setLargecode(String largecode) {
		this.largecode = largecode;
	}
	public String getLargename() {
		return largename;
	}
	public void setLargename(String largename) {
		this.largename = largename;
	}
	public String getMediumcode() {
		return mediumcode;
	}
	public void setMediumcode(String mediumcode) {
		this.mediumcode = mediumcode;
	}
	public String getMediumname() {
		return mediumname;
	}
	public void setMediumname(String mediumname) {
		this.mediumname = mediumname;
	}
	@Override
	public String toString() {
		return "Markettype [id=" + id + ", largecode=" + largecode + ", largename=" + largename + ", mediumcode="
				+ mediumcode + ", mediumname=" + mediumname + "]";
	}
	
	
    
}

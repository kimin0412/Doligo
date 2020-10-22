package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//상권종류
@Data
public class Markettype {
	private int id;			//pk
	private String type1;	//대분류
	private String type2;	//중분류
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getType1() {
		return type1;
	}
	public void setType1(String type1) {
		this.type1 = type1;
	}
	public String getType2() {
		return type2;
	}
	public void setType2(String type2) {
		this.type2 = type2;
	}
	@Override
	public String toString() {
		return "Markettype [id=" + id + ", type1=" + type1 + ", type2=" + type2 + "]";
	}
	
	
    
}

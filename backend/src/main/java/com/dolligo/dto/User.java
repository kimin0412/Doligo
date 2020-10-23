package com.dolligo.dto;

import lombok.Data;

//일반 유저
@Data
public class User {
    private int id;				//pk
    private String email;		//이메일
    private String password;	//비밀번호
    private boolean gender;		//성별 => 여 : 0, 남 : 1
    private int age;			//나이 => 년생으로(뒤에 숫자 두개)
    private int point;			//포인트
    
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public boolean isGender() {
		return gender;
	}
	public void setGender(boolean gender) {
		this.gender = gender;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public User(int id, String email, String password, boolean gender, int age, int point) {
		super();
		this.id = id;
		this.email = email;
		this.password = password;
		this.gender = gender;
		this.age = age;
		this.point = point;
	}
    
    
    
    
}

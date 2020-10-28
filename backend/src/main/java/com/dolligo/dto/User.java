package com.dolligo.dto;

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

//일반 유저
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class User {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;				//pk
    private String email;		//이메일
    private String password;	//비밀번호
    private boolean gender;		//성별 => 여 : 0, 남 : 1
    private int age;			//나이 => 년생으로(뒤에 숫자 두개)
    private int point;			//포인트
    private int addd;
    //private List<Preference> preferences;
    
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
	
//	public List<Preference> getPreferences() {
//		return preferences;
//	}
//	public void setPreferences(List<Preference> preferences) {
//		this.preferences = preferences;
//	}
//	@Override
//	public String toString() {
//		return "User [id=" + id + ", email=" + email + ", password=" + password + ", gender=" + gender + ", age=" + age
//				+ ", point=" + point + ", preferences=" + preferences + "]";
//	}
	
    
    
    
}

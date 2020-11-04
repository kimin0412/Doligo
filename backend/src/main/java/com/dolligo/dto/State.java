package com.dolligo.dto;

//savePoint
public class State {
	private int uid;
	private int pid;
	private boolean gender;
	private int age;
	private int state;
	
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
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	@Override
	public String toString() {
		return "State [uid=" + uid + ", pid=" + pid + ", gender=" + gender + ", age=" + age + ", state=" + state + "]";
	}
	
	
	
	
}

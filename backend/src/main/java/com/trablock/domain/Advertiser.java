package com.trablock.domain;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class Advertiser {
    private long id;
    private String nickname;
    private String email;
    private String password;
    private LocalDateTime createdAt;
    
    
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
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
	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", nickname=" + nickname + ", email=" + email + ", password=" + password + ", createdAt="
				+ createdAt + "]";
	}
    
    
}

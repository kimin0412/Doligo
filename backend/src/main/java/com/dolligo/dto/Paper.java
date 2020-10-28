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

//전단지
@Entity
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Paper {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int p_id;					//pk
    private int p_aid;				//fk  광고주아이디(advertiserId)
    private int p_mtid;				//fk  상권종류 아이디(marketTypeId)
    private String p_image;			//이미지 url
    private String p_video;			//비디오 url
    private String p_qrcode;			//qr코드
    private int p_point;				//포인트
    private boolean p_check;			//전단지 승인 여부
    private String p_coupon;			//쿠폰 내용
	public int getP_id() {
		return p_id;
	}
	public void setP_id(int p_id) {
		this.p_id = p_id;
	}
	public int getP_aid() {
		return p_aid;
	}
	public void setP_aid(int p_aid) {
		this.p_aid = p_aid;
	}
	public int getP_mtid() {
		return p_mtid;
	}
	public void setP_mtid(int p_mtid) {
		this.p_mtid = p_mtid;
	}
	public String getP_image() {
		return p_image;
	}
	public void setP_image(String p_image) {
		this.p_image = p_image;
	}
	public String getP_video() {
		return p_video;
	}
	public void setP_video(String p_video) {
		this.p_video = p_video;
	}
	public String getP_qrcode() {
		return p_qrcode;
	}
	public void setP_qrcode(String p_qrcode) {
		this.p_qrcode = p_qrcode;
	}
	public int getP_point() {
		return p_point;
	}
	public void setP_point(int p_point) {
		this.p_point = p_point;
	}
	public boolean isP_check() {
		return p_check;
	}
	public void setP_check(boolean p_check) {
		this.p_check = p_check;
	}
	public String getP_coupon() {
		return p_coupon;
	}
	public void setP_coupon(String p_coupon) {
		this.p_coupon = p_coupon;
	}
	public Paper() {
		super();
	}
	public Paper(int p_id, int p_aid, int p_mtid, String p_image, String p_video, String p_qrcode, int p_point,
			boolean p_check, String p_coupon) {
		super();
		this.p_id = p_id;
		this.p_aid = p_aid;
		this.p_mtid = p_mtid;
		this.p_image = p_image;
		this.p_video = p_video;
		this.p_qrcode = p_qrcode;
		this.p_point = p_point;
		this.p_check = p_check;
		this.p_coupon = p_coupon;
	}
	
    
}

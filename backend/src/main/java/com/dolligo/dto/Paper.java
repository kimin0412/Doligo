package com.dolligo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

//전단지
@Data
public class Paper {
    private int id;					//pk
    private int aid;				//fk  광고주아이디(advertiserId)
    private int mtid;				//fk  상권종류 아이디(marketTypeId)
    private String image;			//이미지 url
    private String video;			//비디오 url
    private String qrcode;			//qr코드
    private int point;				//포인트
    private boolean check;			//전단지 승인 여부
    private String coupon;			//쿠폰 내용
    
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getVideo() {
		return video;
	}
	public void setVideo(String video) {
		this.video = video;
	}
	public String getQrcode() {
		return qrcode;
	}
	public void setQrcode(String qrcode) {
		this.qrcode = qrcode;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public boolean isCheck() {
		return check;
	}
	public void setCheck(boolean check) {
		this.check = check;
	}
	
	
	public String getCoupon() {
		return coupon;
	}
	public void setCoupon(String coupon) {
		this.coupon = coupon;
	}
	@Override
	public String toString() {
		return "Paper [id=" + id + ", aid=" + aid + ", mtid=" + mtid + ", image=" + image + ", video=" + video
				+ ", qrcode=" + qrcode + ", point=" + point + ", check=" + check + ", coupon=" + coupon + "]";
	}
	
	
    
    
    
    
}

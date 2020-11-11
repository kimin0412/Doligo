package com.dolligo.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

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
import lombok.Setter;

//기프티콘
@Entity
@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)
public class Gifticon {
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column
    private int id;						// pk 아이디
	private String name;				// 상품 이름
	private int price;					// 상품 가격
	private LocalDate validDate;	// 유효기한
	private boolean purchase;			// 구매 여부 => false : 아직 구매 X, true : 누군가 구매
	private String image;				// 기프티콘 이미지 url
	private String code;				// 기프티콘 코드(쿠폰번호)
	private int category;				// 기프티콘 카테고리 1~6
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public LocalDate getValidDate() {
		return validDate;
	}
	public void setValidDate(LocalDate validDate) {
		this.validDate = validDate;
	}
	public boolean isPurchase() {
		return purchase;
	}
	public void setPurchase(boolean purchase) {
		this.purchase = purchase;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
	public int getCategory() {
		return category;
	}
	public void setCategory(int category) {
		this.category = category;
	}
	@Override
	public String toString() {
		return "Gifticon [id=" + id + ", name=" + name + ", price=" + price + ", validDate=" + validDate + ", purchase="
				+ purchase + ", image=" + image + ", code=" + code + ", category=" + category + "]";
	}
	
	
	
    
    
    
    
	
    
}
